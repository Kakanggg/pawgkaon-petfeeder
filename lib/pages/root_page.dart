import 'package:flutter/material.dart';
import '../widgets/main_nav_bar.dart';
import 'home_page.dart';
import 'feeding_schedule_page.dart';
import 'food_page.dart';
import 'feeding_history_page.dart';
import 'pets_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FeedingSchedulePage(),
    FoodPage(),
    const FeedingHistoryPage(),
    const PetsPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Wait until the first frame so that context and ScaffoldMessenger exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == 'loginSuccess') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.pink,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      bottomNavigationBar: MainNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}
