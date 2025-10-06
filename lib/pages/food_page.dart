import 'package:flutter/material.dart';
import 'package:pawgkaon/widgets/food_care_tips_card.dart';
import '../widgets/current_level.dart';
import '../widgets/cup_capacity.dart';
import '../widgets/refill_button.dart';
import '../widgets/header.dart';
import '../widgets/food_level_status_pill.dart';

class FoodPage extends StatefulWidget {
  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  int currentLevel = 0; // start empty
  int cupCapacity = 20;

  void markAsRefilled() => setState(() => currentLevel = cupCapacity);

  void feed() {
    if (currentLevel > 0) setState(() => currentLevel -= 1);
  }

  void scheduleFeed(int portion) {
    if (currentLevel > 0) {
      setState(() {
        currentLevel = (currentLevel - portion).clamp(0, cupCapacity);
      });
    }
  }

  void updateCapacity(int newCapacity) {
    setState(() {
      cupCapacity = newCapacity;
      if (currentLevel > cupCapacity) currentLevel = cupCapacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Store dry food in a cool, dry place',
      'Check expiration dates regularly',
      'Clean the dispenser weekly',
      'Monitor your pet’s eating habits',
      'Use airtight containers for storage',
    ];

    final double percent =
        cupCapacity == 0 ? 0 : (currentLevel / cupCapacity) * 100;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderSection(),
              const SizedBox(height: 16),

              // === Title row with status pill ===
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.pink,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Food Level',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const Spacer(),
                  FoodLevelStatusPill(percentage: percent),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar from CurrentLevel widget
              CurrentLevel(
                currentLevel: currentLevel,
                cupCapacity: cupCapacity,
              ),

              const SizedBox(height: 6),

              // === Percent markers under the bar ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('0%', style: TextStyle(color: Colors.grey)),
                  Text('50%', style: TextStyle(color: Colors.grey)),
                  Text('100%', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),

              CupCapacity(cupCapacity: cupCapacity, onChanged: updateCapacity),
              const SizedBox(height: 2),
              RefillButton(onRefill: markAsRefilled),
              const SizedBox(height: 24),

              Row(
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.pink, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Food Care Tips',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.pink),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              ...tips.map((tip) => FoodCareTipCard(tip: tip)),
            ],
          ),
        ),
      ),
    );
  }
}
