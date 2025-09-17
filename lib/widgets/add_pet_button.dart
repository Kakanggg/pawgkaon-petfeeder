import 'package:flutter/material.dart';

class AddPetButton extends StatelessWidget {
  const AddPetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Navigate to Add Pet Page
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text("Add Pet"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
