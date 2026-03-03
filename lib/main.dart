import 'package:flutter/material.dart';
import 'package:movieapp/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movieapp/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'popcornpals',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const RegisterPage(),
    );
  }
}
