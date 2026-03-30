import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapp/pages/auth_page.dart';
import 'package:movieapp/widgets/app_background.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AppBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 242, 255, 57),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/app_icon.png'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "PopcornPals",
                    style: TextStyle(
                      color: Color.fromARGB(255, 242, 255, 57),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Discover Your Movies",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color.fromARGB(255, 242, 255, 57),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
