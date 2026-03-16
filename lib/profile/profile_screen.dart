import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../navigation_bar.dart';
import '../auth/login_screen.dart';
import 'change_password.dart';
import 'edit_personal_information_screen.dart';
import 'notification.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "profile_screen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  List<dynamic> _userReports = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final url = Uri.parse('${ApiService.baseUrl}/profile');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decodedData['code'] == 200) {
        if (mounted) {
          setState(() {
            _profileData = decodedData['data'];
            _userReports = decodedData['reports'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedData['message'] ?? 'Failed to load profile data')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error occurred')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final url = Uri.parse('${ApiService.baseUrl}/auth/logout/');
    try {
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": "dummy-token-for-now"}),
      );
    } catch (e) {
    }

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileHeaderCard(profileData: _profileData),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Profile Settings'),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          EditPersonalInformationScreen.routeName,
                        ).then((_) => _fetchProfileData());
                      },
                      child: const _SettingTile(
                        icon: Icons.person_outline,
                        title: 'Edit Personal Information',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ChangePasswordScreen.routeName,
                        );
                      },
                      child: const _SettingTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          NotificationScreen.routeName,
                        );
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
                    const _SectionTitle(title: 'My Reports'),
                    const SizedBox(height: 12),
                    if (_userReports.isEmpty)
                      const Text(
                        'No reports found.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ..._userReports.map((report) {
                        return _ReportCard(
                          title: report['title'] ?? 'Unknown',
                          reportId: report['id']?.toString() ?? '#000',
                          date: report['date'] ?? 'N/A',
                          status: report['status'] ?? 'Pending',
                          statusColor: _getStatusColor(report['status']),
                        );
                      }),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'More'),
                    const SizedBox(height: 12),
                    const _SettingTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                    ),
                    const _SettingTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                    ),
                    const _SettingTile(
                      icon: Icons.description_outlined,
                      title: 'Terms and Conditions',
                      isLast: true,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _logout,
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

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'solved':
      case 'placed':
        return const Color(0xFF32D583);
      case 'in progress':
        return const Color(0xFFFDB022);
      case 'cancelled':
        return const Color(0xFFF04438);
      default:
        return Colors.blue;
    }
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final Map<String, dynamic>? profileData;

  const _ProfileHeaderCard({required this.profileData});

  @override
  Widget build(BuildContext context) {
    final String name = profileData?['name'] ?? 'Loading...';
    final String phone = profileData?['phone'] ?? 'Loading...';
    final String trackStat = profileData?['total_complaints']?.toString() ?? '0';
    final String solvedStat = profileData?['resolved_complaints']?.toString() ?? '0';
    final String pointStat = profileData?['points']?.toString() ?? '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E90FA),
            Color(0xFF1570EF),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatBox(label: 'Track', value: trackStat),
              _StatBox(label: 'Solved', value: solvedStat),
              _StatBox(label: 'Point', value: pointStat),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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

class _BottomNavBarPlaceholder extends StatelessWidget {
  const _BottomNavBarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const NavigationBarr(currentIndex: 3);
  }
}