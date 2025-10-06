import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../widgets/header.dart';
import '../widgets/feeding_history_card.dart';

class FeedingHistoryPage extends StatelessWidget {
  const FeedingHistoryPage({super.key});

  /// Fetch all feeding history for pets belonging to the current user
  /// Realtime stream of ALL feeding histories of this user’s pets
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _allFeedingHistory(
    String uid,
  ) async* {
    final petsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('pets')
            .get();

    // For each pet, create a stream of feedingHistory
    final streams = petsSnapshot.docs.map((petDoc) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('pets')
          .doc(petDoc.id)
          .collection('feedingHistory')
          .orderBy('time', descending: true)
          .snapshots();
    });

    // Merge them all into one combined stream
    yield* StreamZip(streams).map((listOfSnapshots) {
      // Flatten all docs into one list
      return listOfSnapshots.expand((snap) => snap.docs).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final uid = userSnapshot.data!.uid;

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
                    children: const [
                      Icon(Icons.history, color: Colors.pink, size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Feeding History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    >(
                      stream: _allFeedingHistory(uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Something went wrong"),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!;
                        if (docs.isEmpty) {
                          return _buildEmptyMessage();
                        }

                        final now = DateTime.now();
                        final history =
                            docs
                                .where(
                                  (d) =>
                                      (d['time'] as Timestamp?)
                                          ?.toDate()
                                          .isBefore(now) ??
                                      false,
                                )
                                .toList();

                        if (history.isEmpty) {
                          return _buildEmptyMessage();
                        }

                        // Sort newest first
                        history.sort((a, b) {
                          final aTime = (a['time'] as Timestamp).toDate();
                          final bTime = (b['time'] as Timestamp).toDate();
                          return bTime.compareTo(aTime);
                        });

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final data = history[index].data();
                            final petName =
                                data['petName'] as String? ?? "Unknown";
                            final feedTime =
                                (data['time'] as Timestamp).toDate();
                            final timeString = DateFormat.jm().format(feedTime);
                            final isManual = data['isManual'] as bool? ?? false;
                            final amount = data['amount']?.toString() ?? '1';

                            return FeedingHistoryCard(
                              petName: petName,
                              time: timeString,
                              amount: amount,
                              isManual: isManual,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Text(
        "Your pets haven't eaten yet.",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 18,
          color: Colors.pink.withOpacity(0.5),
        ),
      ),
    );
  }
}
