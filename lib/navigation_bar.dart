import 'package:flutter/material.dart';
import 'package:grad_project/home/home_screen.dart';
import 'package:grad_project/map_screen.dart';
import 'package:grad_project/profile/profile_screen.dart';
import 'package:grad_project/track_report/track_report.dart';

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
        color: Colors.white,
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
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                  context, HomeScreen.routeName);
              break;
            case 1:
              Navigator.pushReplacementNamed(
                  context, MapScreen.routeName);
              break;
            case 2:
              Navigator.pushReplacementNamed(
                  context, TrackReportScreen.routeName);
              break;
            case 3:
              Navigator.pushReplacementNamed(
                  context, ProfileScreen.routeName);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'My Account',
          ),
        ],
      ),
    );
  }
}