import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/header.dart';
import '../widgets/schedule_card.dart';
import '../widgets/add_schedule_button.dart';
import '../widgets/add_schedule_dialog.dart';
import '../widgets/confirm_action_dialog.dart';
import '../widgets/edit_schedule_dialog.dart';

class FeedingSchedulePage extends StatefulWidget {
  const FeedingSchedulePage({super.key});

  @override
  State<FeedingSchedulePage> createState() => _FeedingSchedulePageState();
}

class _FeedingSchedulePageState extends State<FeedingSchedulePage> {
  bool _adding = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _schedules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get all pets
      final petsSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('pets')
              .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> allSchedules = [];

      for (final petDoc in petsSnap.docs) {
        final schedulesSnap =
            await petDoc.reference
                .collection('schedules')
                .orderBy('time', descending: true)
                .get();

        allSchedules.addAll(schedulesSnap.docs);
      }

      if (mounted) {
        setState(() {
          _schedules = allSchedules;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load schedules: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderSection(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, color: Colors.pink, size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Daily Feeding Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  AddScheduleButton(
                    isLoading: _adding,
                    onPressed: () async {
                      setState(() => _adding = true);
                      final added = await showDialog<bool>(
                        context: context,
                        builder: (_) => const AddScheduleDialog(),
                      );
                      setState(() => _adding = false);
                      if (added == true && context.mounted) {
                        await _loadSchedules(); // Refresh schedules
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Feeding schedule successfully added.',
                            ),
                            backgroundColor: Colors.pink,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _schedules.isEmpty
                        ? Center(
                          child: Text(
                            'Oops! No feeding schedules yet.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              color: Colors.pink.withOpacity(0.5),
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _schedules.length,
                          itemBuilder: (context, index) {
                            final data = _schedules[index].data();
                            final timeStamp = data['time'] as Timestamp?;
                            final timeText =
                                timeStamp != null
                                    ? TimeOfDay.fromDateTime(
                                      timeStamp.toDate(),
                                    ).format(context)
                                    : '';
                            final petRef = data['petRef'] as DocumentReference?;

                            if (petRef != null) {
                              return FutureBuilder<DocumentSnapshot>(
                                future: petRef.get(),
                                builder: (context, petSnapshot) {
                                  String petName = data['petName'] ?? 'Pet';
                                  if (petSnapshot.hasData &&
                                      petSnapshot.data!.exists) {
                                    final petData =
                                        petSnapshot.data!.data()
                                            as Map<String, dynamic>?;
                                    if (petData != null &&
                                        petData['name'] != null) {
                                      petName = petData['name'];
                                    }
                                  }
                                  return _buildScheduleCard(
                                    _schedules[index],
                                    timeText,
                                    petName,
                                    data,
                                  );
                                },
                              );
                            } else {
                              final petName = data['petName'] ?? 'Pet';
                              return _buildScheduleCard(
                                _schedules[index],
                                timeText,
                                petName,
                                data,
                              );
                            }
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String timeText,
    String petName,
    Map<String, dynamic> data,
  ) {
    return ScheduleCard(
      time: timeText,
      petName: petName,
      amount: '${data['portion'] ?? 1}',
      onEdit: () async {
        final updated = await showDialog<bool>(
          context: context,
          builder:
              (_) => EditScheduleDialog(
                scheduleRef: doc.reference,
                currentTime: timeText,
                currentPortion: '${data['portion'] ?? 1}',
              ),
        );
        if (updated == true && context.mounted) {
          await _loadSchedules();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feeding schedule updated successfully.'),
              backgroundColor: Colors.pink,
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      onDelete: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (_) => const ConfirmActionDialog(
                title: 'Delete Schedule',
                message: 'Delete this feeding schedule?',
                confirmText: 'Remove',
                confirmColor: Colors.pink,
                icon: Icons.schedule,
              ),
        );
        if (confirmed == true) {
          doc.data();

          // Delete from Firestore
          await doc.reference.delete();

          if (context.mounted) {
            await _loadSchedules();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feeding schedule successfully deleted.'),
                backgroundColor: Colors.pink,
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      },
    );
  }
}
