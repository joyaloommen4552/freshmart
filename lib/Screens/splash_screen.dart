import 'package:flutter/material.dart';

import 'package:freshmart/Screens/login_screen.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                width: ScreenConfig.blockWidth * 75,
              ),

              SizedBox(height: ScreenConfig.blockHeight * 3),

              Text(
                "FreshMart",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: ScreenConfig.blockWidth * 8,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: ScreenConfig.blockHeight * 1.5),

              Text(
                "Freshness Delivered",
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: ScreenConfig.blockWidth * 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
