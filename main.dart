import 'package:flutter/material.dart';
import 'screens/navigation_controller.dart';

void main() {
  runApp(const OneParkApp());
}

class OneParkApp extends StatelessWidget {
  const OneParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnePark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF1B4242),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFECE5C7),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1B4242)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1B4242),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}