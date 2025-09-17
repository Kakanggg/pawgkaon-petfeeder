import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool isConnected;
  final int petsCount;

  const StatusCard({
    super.key,
    required this.isConnected,
    required this.petsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.pink.shade200),
      ),
      color: Colors.pink.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Connected status + pets info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Connected Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isConnected ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        isConnected ? "Connected" : "Disconnected",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // ✅ Pets and Online status
                Row(
                  children: [
                    Text(
                      "$petsCount pets",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isConnected ? "Online" : "Offline",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),

            // Right Side: User Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.pink.shade100,
              child: const Icon(Icons.person, color: Colors.pink, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
