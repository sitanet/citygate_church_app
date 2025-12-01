import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;

  const SplashScreen({
    Key? key,
    required this.onComplete,
    this.duration = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.darkGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Optional subtle overlay for contrast
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.08)),
          ),
        ],
      ),
    );
  }
}