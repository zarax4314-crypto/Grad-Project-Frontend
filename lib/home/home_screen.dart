import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../map_screen.dart';
import '../navigation_bar.dart';
import '../new_report/new_report_screen.dart';
import '../track_report/track_report.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(31.435658, 31.674627),
    zoom: 13,
  );

  List<dynamic> _recentReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecentReports();
  }

  Future<void> fetchRecentReports() async {
    final url = Uri.parse('${ApiService.baseUrl}/complaints');

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
            _recentReports = decodedData['data'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationBar(screenWidth),
                const SizedBox(height: 20.0),
                _buildActionButtonsRow(context),
                const SizedBox(height: 20.0),
                _buildRewardBannerCard(screenWidth),
                const SizedBox(height: 20.0),
                _buildReportsMapCard(context, screenWidth),
                const SizedBox(height: 20.0),
                _buildRecentReportsSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildLocationBar(double screenWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.blue),
          const SizedBox(width: 8.0),
          const Text(
            'New Damietta City',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionButton(
          icon: Icons.add,
          text: 'New Report',
          onTap: () {
            Navigator.pushNamed(
              context,
              NewReportScreen.routeName,
            );
          },
        ),
        ActionButton(
          icon: Icons.location_on_outlined,
          text: 'Map',
          onTap: () {
            Navigator.pushNamed(
              context,
              MapScreen.routeName,
            );
          },
        ),
        ActionButton(
          icon: Icons.track_changes,
          text: 'Track Report',
          onTap: () {
            Navigator.pushNamed(
              context,
              TrackReportScreen.routeName,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRewardBannerCard(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get a Reward',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Report 5 problems and get a certificate of appreciation from the municipality',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                'Details >',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsMapCard(BuildContext context, double screenWidth) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reports map',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MapScreen(title: "Reports Map"),
                      ),
                    );
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapScreen(title: "Reports Map"),
                  ),
                );
              },
              child: SizedBox(
                height: screenWidth * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    onMapCreated: (controller) {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Reports',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'More',
                style: TextStyle(color: Colors.blue, fontSize: 14.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recentReports.isEmpty
                ? const Center(
                    child: Text(
                      'No recent reports found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentReports.length,
                    itemBuilder: (context, index) {
                      final report = _recentReports[index];
                      
                      String reportDate = report['date'] ?? '';
                      if (reportDate.isEmpty && report['created_at'] != null) {
                        reportDate = report['created_at'].toString().substring(0, 10);
                      }
                      if (reportDate.isEmpty) reportDate = 'N/A';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ReportCard(
                          title: report['title'] ?? 'Unknown Issue',
                          street: report['location_address'] ?? 'Unknown Location',
                          date: reportDate,
                          status: report['status'] ?? 'Pending',
                        ),
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return const NavigationBarr(currentIndex: 0);
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                offset: Offset(1, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.blue,
              ),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String street;
  final String date;
  final String status;

  const ReportCard({
    super.key,
    required this.title,
    required this.street,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text(
                        street,
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}