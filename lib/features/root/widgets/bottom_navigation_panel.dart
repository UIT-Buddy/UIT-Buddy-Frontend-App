import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class BottomNavigationPanel extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationPanel({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColor.dividerGrey, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: AppColor.primaryBlue,
        unselectedItemColor: AppColor.secondaryText,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.pureWhite,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: 'Storage',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
