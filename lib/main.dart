import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Security System',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFF1F2937), // Dark gray from UI
        scaffoldBackgroundColor: const Color(0xFFE9E9E9), // Light gray background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}