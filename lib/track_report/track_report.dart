import 'package:flutter/material.dart';
import 'package:grad_project/track_report/track_report2.dart';
import '../navigation_bar.dart';

class ReportModel {
  final String title;
  final String description;
  final String location;
  final String number;
  final String status;

  ReportModel({
    required this.title,
    required this.description,
    required this.location,
    required this.number,
    required this.status,
  });
}

class TrackReportScreen extends StatefulWidget {
  static const String routeName = "track_report";

  const TrackReportScreen({super.key});

  @override
  State<TrackReportScreen> createState() => _TrackReportScreenState();
}

class _TrackReportScreenState extends State<TrackReportScreen> {
  Widget _buildBottomNavigationBar() {
    return NavigationBarr(currentIndex: 2);
  }

  final List<ReportModel> _allReports = [
    ReportModel(
      title: 'Hole on main street',
      description:
      'There is a large hole on King Fahd Street, causing a danger to cars',
      location: 'King Fahd Street, Riyadh',
      number: '#BR2023-452',
      status: 'Solved',
    ),
    ReportModel(
      title: 'Broken traffic light',
      description:
      'Traffic light at intersection of Olaya and Tahlia is not working',
      location: 'Olaya Street, Riyadh',
      number: '#BR2023-453',
      status: 'In Progress',
    ),
    ReportModel(
      title: 'Water leakage',
      description: 'Water pipe burst near the park, flooding the area',
      location: 'Al-Malaz Park, Riyadh',
      number: '#BR2023-454',
      status: 'Cancelled',
    ),
    ReportModel(
      title: 'Street light out',
      description:
      'Several street lights are not working on Prince Sultan Street',
      location: 'Prince Sultan Street, Jeddah',
      number: '#BR2023-455',
      status: 'Solved',
    ),
  ];

  String _selectedFilter = 'All';

  List<ReportModel> get _filteredReports {
    if (_selectedFilter == 'All') {
      return _allReports;
    } else {
      return _allReports
          .where((report) => report.status == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Track Report',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Track Number',
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterButton(
                    text: 'All',
                    isSelected: _selectedFilter == 'All',
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'All';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: 'Solved',
                    isSelected: _selectedFilter == 'Solved',
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Solved';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: 'In Progress',
                    isSelected: _selectedFilter == 'In Progress',
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'In Progress';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterButton(
                    text: 'Cancelled',
                    isSelected: _selectedFilter == 'Cancelled',
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'Cancelled';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                final report = _filteredReports[index];
                return ReportCard(report: report);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isSelected ? const Color(0xFF0088FF) : const Color(0xFFEAEAEA),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      child: Text(text),
    );
  }
}

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Solved':
        return const Color(0xFF27C840);
      case 'In Progress':
        return const Color(0xFFFEBC2F);
      case 'Cancelled':
        return const Color(0xFFFF2D55);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (report.status == 'In Progress') {
          Navigator.pushNamed(
            context,
            TrackReporttScreen.routeName,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(
                  status: report.status,
                  color: _getStatusColor(report.status),
                ),
                Text(
                  report.number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              report.title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(report.description),
            const SizedBox(height: 5),
            Text(
              report.location,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildActionButton(Icons.call, 'Call'),
                const SizedBox(width: 10),
                _buildActionButton(Icons.share, 'Share'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
        label: Text(label, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF0F0F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge(
      {super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style:
        const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}