import 'package:flutter/material.dart';
import 'package:grad_project/home/home_screen.dart';
import 'package:grad_project/map_screen.dart';
import 'package:grad_project/profile/profile_screen.dart';
import 'package:grad_project/track_report/track_report.dart';
import 'colors.dart';

class NavigationBarr extends StatelessWidget {
  final int currentIndex;

  const NavigationBarr({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.card,
        elevation: 0,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.selectedNav,
        unselectedItemColor: AppColors.unselectedNav,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, MapScreen.routeName);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, TrackReportScreen.routeName);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}