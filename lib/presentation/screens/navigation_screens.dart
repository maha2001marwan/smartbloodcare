import 'package:flutter/material.dart';

import 'donor_form_screen.dart';
import 'donor_list_screen.dart';
import 'guidelines_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class NavigationScreens extends StatefulWidget {
  final int initialIndex;

  const NavigationScreens({super.key, this.initialIndex = 0});

  @override
  State<NavigationScreens> createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  late int _selectedIndex;

  static const List<Widget> _screens = [
    HomeScreen(),
    DonorsListScreen(),
    BloodRequestForm(),
    HealthTipsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _screens.length - 1);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFF1D7D7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                height: 72,
                elevation: 0,
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFFFFE4E6),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: _onItemTapped,
                destinations: const [
                  NavigationDestination(
                    selectedIcon: Icon(Icons.home_rounded),
                    icon: Icon(Icons.home_outlined),
                    label: 'الرئيسية',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.people_alt_rounded),
                    icon: Icon(Icons.people_alt_outlined),
                    label: 'المتبرعون',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.add_circle_rounded),
                    icon: Icon(Icons.add_circle_outline_rounded),
                    label: 'طلب دم',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.health_and_safety_rounded),
                    icon: Icon(Icons.health_and_safety_outlined),
                    label: 'إرشادات',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.person_rounded),
                    icon: Icon(Icons.person_outline_rounded),
                    label: 'حسابي',
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
