import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart'; // Add this import
import 'screens/main_screen.dart';

void main() {
  runApp(const CityGateChurchApp());
}

class CityGateChurchApp extends StatelessWidget {
  const CityGateChurchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The CityGate Church',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _showSplash = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  void _onSignInComplete() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _onSignUpComplete() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _onSignOut() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onComplete: () {
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      });
    }

    if (!_isAuthenticated) {
      return WelcomeScreen(
        onSignIn: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignInScreen(
                onSignIn: _onSignInComplete,
              ),
            ),
          );
        },
        onSignUp: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignUpScreen(
                onSignUp: _onSignUpComplete,
              ),
            ),
          );
        },
      );
    }

    return MainScreen(onSignOut: _onSignOut);
  }
}