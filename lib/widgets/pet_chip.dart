import 'package:flutter/material.dart';

class PetChip extends StatelessWidget {
  final String name;
  const PetChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(name),
      backgroundColor: Colors.pink[50],
      labelStyle: const TextStyle(color: Colors.pink),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
