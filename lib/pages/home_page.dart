import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/header.dart';
import '../widgets/home_card.dart';
import '../widgets/pet_chip.dart';
import '../widgets/feed_button.dart';
import '../widgets/status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final user = authSnapshot.data;

        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "You are logged out. Please login again.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final uid = user.uid;
        final petsRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('pets');

        return SafeArea(
          child: Container(
            color: Colors.pink.shade50,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<QuerySnapshot>(
                stream: petsRef.snapshots(),
                builder: (context, petSnapshot) {
                  if (!petSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pets = petSnapshot.data!.docs;
                  final petsCount = pets.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HeaderSection(),
                      const SizedBox(height: 16),
                      StreamBuilder<DocumentSnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .snapshots(),
                        builder: (context, userSnap) {
                          if (!userSnap.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final userData =
                              userSnap.data!.data() as Map<String, dynamic>?;
                          final profileImageBase64 =
                              userData?['profileImageBase64'];

                          return StatusCard(
                            isConnected: true,
                            imageBase64: profileImageBase64,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _getUpcomingFeeding(pets),
                              builder: (context, scheduleSnapshot) {
                                if (!scheduleSnapshot.hasData) {
                                  return const HomeCard(
                                    icon: Icons.access_time,
                                    title: "Next Feeding",
                                    value: "--:--",
                                    subtitle: "Loading...",
                                  );
                                }

                                final upcoming = scheduleSnapshot.data!;
                                if (upcoming.isEmpty) {
                                  return const HomeCard(
                                    icon: Icons.access_time,
                                    title: "Next Feeding",
                                    value: "--:--",
                                    subtitle: "No schedule",
                                  );
                                }

                                final next = upcoming.first;
                                final feedingTime =
                                    (next['time'] as Timestamp).toDate();
                                final formattedTime = TimeOfDay.fromDateTime(
                                  feedingTime,
                                ).format(context);
                                final diff = feedingTime.difference(
                                  DateTime.now(),
                                );
                                final hours = diff.inHours;
                                final minutes = diff.inMinutes % 60;
                                final petName = next['petName'] ?? 'Pet';

                                return HomeCard(
                                  icon: Icons.access_time,
                                  title: "Next Feeding",
                                  value: formattedTime,
                                  subtitle: "$petName in ${hours}h ${minutes}m",
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: HomeCard(
                              icon: Icons.layers,
                              title: "Food Level",
                              value: "100%",
                              subtitle: "Good Level",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.pink.shade200,
                            width: 1,
                          ),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.pets, color: Colors.pink),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Your Pets ($petsCount)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children:
                                    pets.map((doc) {
                                      final petData =
                                          doc.data() as Map<String, dynamic>? ??
                                          {};
                                      return PetChip(
                                        name: petData['name'] ?? "Pet",
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.pink.shade200,
                            width: 1,
                          ),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Manual Feeding",
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Feed your pets manually outside of their regular schedule.",
                                style: TextStyle(color: Colors.black38),
                              ),
                              const SizedBox(height: 12),
                              ...pets.map((doc) {
                                final petData =
                                    doc.data() as Map<String, dynamic>? ?? {};
                                return FeedButton(
                                  petName: petData['name'] ?? "Pet",
                                  petRef: doc.reference,
                                  amount:
                                      petData['cupsPerPortion']?.toString() ??
                                      "1",
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getUpcomingFeeding(
    List<QueryDocumentSnapshot> pets,
  ) async {
    final now = DateTime.now();
    List<Map<String, dynamic>> upcoming = [];

    for (final pet in pets) {
      final schedulesSnap = await pet.reference.collection('schedules').get();

      for (final s in schedulesSnap.docs) {
        final data = s.data();
        final time = (data['time'] as Timestamp?)?.toDate();
        if (time != null && time.isAfter(now)) {
          upcoming.add({
            ...data,
            'petName':
                data['petName'] ?? (pet.data() as Map<String, dynamic>)['name'],
          });
        }
      }
    }

    upcoming.sort(
      (a, b) => (a['time'] as Timestamp).toDate().compareTo(
        (b['time'] as Timestamp).toDate(),
      ),
    );

    return upcoming;
  }
}
