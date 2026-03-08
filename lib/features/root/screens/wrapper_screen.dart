import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:uit_buddy_mobile/features/root/widgets/bottom_navigation_panel.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/new_feed_screen.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/screens/storage_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/profile_screen.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = const [
    HomeScreen(),
    CalendarScreen(),
    NewFeedScreen(),
    StorageScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationPanel(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
