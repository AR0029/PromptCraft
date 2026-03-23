import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../navigation/main_scaffold.dart';
import '../../core/constants/app_colors.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const MainScaffold(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, size: 50, color: AppColors.primaryLight),
                ),
              ],
            ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack).shimmer(delay: 800.ms, duration: 1500.ms),
            
            const SizedBox(height: 32),
            
            const Text(
              'PromptCraft',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 16),
            
            Text(
              'Master the Art of AI Communication',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 0.5,
              ),
            ).animate().fade(delay: 800.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 60),
            
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.8),
                strokeWidth: 3,
              ),
            ).animate().fade(delay: 1200.ms),
          ],
        ),
      ),
    );
  }
}
