import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final bool isConnected;
  final int petsOnline;

  const HeaderSection({
    super.key,
    required this.title,
    required this.isConnected,
    required this.petsOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.mode_night_outlined, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
