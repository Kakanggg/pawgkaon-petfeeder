import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const PawgKaonApp());

class PawgKaonApp extends StatelessWidget {
  const PawgKaonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawgKaon',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
