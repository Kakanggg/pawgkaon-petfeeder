import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String initial;
  final String name;
  final String type;
  final String weight;
  final String lastFed;
  final String portions;

  const PetCard({
    super.key,
    required this.initial,
    required this.name,
    required this.type,
    required this.weight,
    required this.lastFed,
    required this.portions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.pink.shade100, width: 1),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.pink,
                          ),
                        ],
                      ),
                      Text(type, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Edit Pet Info
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Edit"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.monitor_weight_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(weight, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  "Last fed: $lastFed",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  portions,
                  style: const TextStyle(color: Colors.pink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
