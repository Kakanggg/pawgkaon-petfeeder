import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/home_card.dart';
import '../widgets/pet_chip.dart';
import '../widgets/feed_button.dart';
import '../widgets/main_nav_bar.dart';
import '../widgets/status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    // TODO: Implement navigation logic to other pages here
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
          children: [
            const SizedBox(height: 16),
            const HeaderSection(
              title: "PawgKaon",
              isConnected: true,
              petsOnline: 2,
            ),
            const SizedBox(height: 16),
            const StatusCard(isConnected: true, petsCount: 2),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: HomeCard(
                    icon: Icons.access_time,
                    title: "Next Feeding",
                    value: "7:00 AM",
                    subtitle: "Willow in 7h 30m",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: HomeCard(
                    icon: Icons.layers_outlined,
                    title: "Food Level",
                    value: "100%",
                    subtitle: "Good Level",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.pink.shade200, width: 1),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets, color: Colors.pink),
                        SizedBox(width: 8),
                        Text(
                          "Your Pets (2)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: const [
                        PetChip(name: "Willow"),
                        PetChip(name: "Mochi"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.pink.shade200, width: 1),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manual Feeding",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Feed your pets manually outside of their regular schedule.",
                      style: TextStyle(color: Colors.black38),
                    ),
                    const SizedBox(height: 12),
                    const FeedButton(petName: "Willow"),
                    const SizedBox(height: 8),
                    const FeedButton(petName: "Mochi"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
