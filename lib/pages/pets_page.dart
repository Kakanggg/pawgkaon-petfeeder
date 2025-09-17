import 'package:flutter/material.dart';
import '../widgets/main_nav_bar.dart';
import '../widgets/pet_card.dart';
import '../widgets/header.dart';
import '../widgets/add_pet_button.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  int _selectedIndex = 4; // Pets tab active

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Implement navigation to other pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      bottomNavigationBar: MainNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            SizedBox(height: 16),
            HeaderSection(title: "PawgKaon", isConnected: true, petsOnline: 2),
            SizedBox(height: 16),

            // Row for "My Pets" + Add Pet button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Pets",
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                AddPetButton(),
              ],
            ),

            SizedBox(height: 16),
            PetCard(
              initial: "W",
              name: "Willow",
              type: "Golden Retriever • 3 years old",
              weight: "29.5 kg",
              lastFed: "7h ago",
              portions: "2 portions/day",
            ),
            SizedBox(height: 12),
            PetCard(
              initial: "M",
              name: "Mochi",
              type: "Maine Coon • 2 years old",
              weight: "5.4 kg",
              lastFed: "5h ago",
              portions: "3 portions/day",
            ),
          ],
        ),
      ),
    );
  }
}
