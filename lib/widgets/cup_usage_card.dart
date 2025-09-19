import 'package:flutter/material.dart';

class CupUsageCard extends StatelessWidget {
  final int cupCapacity;
  final int dailyUsage;

  const CupUsageCard({
    Key? key,
    required this.cupCapacity,
    required this.dailyUsage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.pink.shade100),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Cup Capacity
            Column(
              children: [
                Text(
                  "$cupCapacity",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Cup Capacity",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            /// Daily Usage
            Column(
              children: [
                Text(
                  "${dailyUsage}x",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Daily Usage",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}