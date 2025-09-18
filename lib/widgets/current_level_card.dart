import 'package:flutter/material.dart';

class CurrentLevelCard extends StatelessWidget {
  final int currentLevel;
  final int maxLevel;
  final int estimatedDays;
  final VoidCallback onRefill;

  const CurrentLevelCard({
    Key? key,
    required this.currentLevel,
    required this.maxLevel,
    required this.estimatedDays,
    required this.onRefill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentLevel / maxLevel;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.pink.shade100),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Level
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Current Level",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "$currentLevel/$maxLevel cups",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.pink.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            ),

            const SizedBox(height: 6),

            /// Progress Percent Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("0%", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text("75%", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text("100%", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 10),

            /// Estimated days + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated $estimatedDays days remaining",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onRefill,
                  child: const Text("Refilled"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}