import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const WelcomeScreen({
    Key? key,
    required this.onSignIn,
    required this.onSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background (with graceful fallback)
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcome.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, _, __) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.darkGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Light overlay for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.28),
                      Colors.black.withOpacity(0.50),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Three-line title on the left near the head
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, c) {
                  final h = c.maxHeight;
                  // Adjust these two to nudge the block if needed
                  final topOffset = h * 0.20; // ~upper-left near the head
                  const leftPadding = 20.0;

                  return Padding(
                    padding: EdgeInsets.only(top: topOffset, left: leftPadding, right: 24),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: c.maxWidth * 0.75),
                        child: const _ThreeLineTitle(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom buttons
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onSignUp,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textLight,
                          side: const BorderSide(color: AppColors.textLight, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreeLineTitle extends StatelessWidget {
  const _ThreeLineTitle();

  @override
  Widget build(BuildContext context) {
    // Emphasize the middle word
    const shadow = [
      Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black45),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Stay',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -0.3,
            shadows: shadow,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Connected',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 40, // bigger middle line
            fontWeight: FontWeight.w800,
            height: 1.02,
            letterSpacing: -0.6,
            shadows: shadow,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'With Light',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.05,
            letterSpacing: -0.3,
            shadows: shadow,
          ),
        ),
      ],
    );
  }
}