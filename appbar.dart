import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;

  const HeaderSection({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.mode_night_outlined, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
