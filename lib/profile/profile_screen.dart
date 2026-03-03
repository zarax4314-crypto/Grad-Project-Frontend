import 'package:flutter/material.dart';

import '../navigation_bar.dart';
import 'change_password.dart';
import 'edit_personal_information_screen.dart';
import 'notification.dart';

/// ProfileScreen is a self-contained Flutter widget that matches the provided Figma design.
/// It uses Material 3 and is designed for mobile portrait view.
class ProfileScreen extends StatelessWidget {
  static const String routeName = "profile_screen";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Background color: #F8F9FC
    const backgroundColor = Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Profile Header Card
              const _ProfileHeaderCard(),
              const SizedBox(height: 24),

              // 2) Profile Settings Section
              const _SectionTitle(title: 'Profile Settings'),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    EditPersonalInformationScreen.routeName,
                  );
                },
                child: const _SettingTile(
                  icon: Icons.person_outline,
                  title: 'Edit Personal Information',
                ),
              ),
          InkWell(onTap: (){Navigator.pushNamed(
            context,
            ChangePasswordScreen.routeName,
          );},
            child:
            const _SettingTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
              ),),

              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, NotificationScreen.routeName);
                },
                child: const _SettingTile(
                  icon: Icons.notifications_none,
                  title: 'Notification',
                ),
              ),
              const _SettingTile(
                icon: Icons.language,
                title: 'Language',
                isLast: true,
              ),
              const SizedBox(height: 24),

              // 3) My Reports Section
              const _SectionTitle(title: 'My Reports'),
              const SizedBox(height: 12),
              const _ReportCard(
                title: 'Hole on main street',
                reportId: '#BR2023-452',
                date: '1/5/2025',
                status: 'In Progress',
                statusColor: Color(0xFFFDB022), // Orange
              ),
              const _ReportCard(
                title: 'Hole on main street',
                reportId: '#BR2023-452',
                date: '1/5/2025',
                status: 'Solved',
                statusColor: Color(0xFF32D583), // Green
              ),
              const _ReportCard(
                title: 'Hole on main street',
                reportId: '#BR2023-452',
                date: '1/5/2025',
                status: 'Cancelled',
                statusColor: Color(0xFFF04438), // Red
              ),
              const SizedBox(height: 24),

              // 4) More Section
              const _SectionTitle(title: 'More'),
              const SizedBox(height: 12),
              const _SettingTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
              ),
              const _SettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'privacy policy',
              ),
              const _SettingTile(
                icon: Icons.description_outlined,
                title: 'Terms and Conditions',
                isLast: true,
              ),
              const SizedBox(height: 32),

              // 5) Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF04438)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFF04438),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavBarPlaceholder(),
    );
  }
}

/// Profile Header Card with Gradient and Stats
class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E90FA), // Bright Blue
            Color(0xFF1570EF), // Darker Blue
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmed Mohamed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ahmed525@gmail.com',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatBox(label: 'Track', value: '5'),
              _StatBox(label: 'Solved', value: '5'),
              _StatBox(label: 'Point', value: '5'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 100) / 3,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section Title
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF101828),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Setting Tile for Settings and More sections
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLast;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF344054), size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF667085),
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Report Card for My Reports section
class _ReportCard extends StatelessWidget {
  final String title;
  final String reportId;
  final String date;
  final String status;
  final Color statusColor;

  const _ReportCard({
    required this.title,
    required this.reportId,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF101828),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _StatusBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reportId,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
              ),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Status Badge for Report Card
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Bottom Navigation Bar Placeholder UI
class _BottomNavBarPlaceholder extends StatelessWidget {
  const _BottomNavBarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return NavigationBarr(currentIndex: 3);
  }
}

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//
//   const _NavItem({
//     required this.icon,
//     required this.label,
//     this.isActive = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final color = isActive ? const Color(0xFF1570EF) : const Color(0xFF667085);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontSize: 10,
//             fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }
