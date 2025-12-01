import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'media_screen.dart';
import 'chat_screen.dart';
import 'menu_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onSignOut;
  
  const MainScreen({
    Key? key,
    required this.onSignOut,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const MediaScreen(),
      const LiveScreen(),
      const ChatScreen(),
      MenuScreen(onSignOut: widget.onSignOut),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  index: 0,
                  label: 'Home',
                ),
                _buildNavItem(
                  icon: Icons.library_music,
                  index: 1,
                  label: 'Media',
                ),
                _buildNavItem(
                  icon: Icons.play_circle_fill,
                  index: 2,
                  label: 'Live',
                  isLarge: true,
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble,
                  index: 3,
                  label: 'Chat',
                ),
                _buildNavItem(
                  icon: Icons.menu,
                  index: 4,
                  label: 'Menu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
    bool isLarge = false,
  }) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isLarge ? 12 : 8),
        decoration: BoxDecoration(
          gradient: isSelected && !isLarge
              ? const LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: isLarge
              ? (isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.8))
              : (isSelected ? null : Colors.transparent),
          borderRadius: BorderRadius.circular(isLarge ? 20 : 12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isLarge ? 28 : 24,
              color: isSelected
                  ? (isLarge ? AppColors.textPrimary : AppColors.textLight)
                  : AppColors.textSecondary,
            ),
            if (!isLarge) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textLight
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}