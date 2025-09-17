import 'package:flutter/material.dart';

class FeedButton extends StatelessWidget {
  final String petName;
  const FeedButton({super.key, required this.petName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // feeding logic here
      },
      icon: const Icon(Icons.play_arrow_outlined, color: Colors.pink),
      label: Text("Feed $petName", style: TextStyle(color: Colors.pink)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[50],
        minimumSize: const Size.fromHeight(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.pink, width: 0.5),
        ),
      ),
    );
  }
}
