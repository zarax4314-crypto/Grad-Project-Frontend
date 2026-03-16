import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    String rawStatus = json['status']?.toString() ?? 'Pending';
    if (rawStatus.toLowerCase() == 'placed') {
      rawStatus = 'In Progress';
    } else if (rawStatus.isNotEmpty) {
      rawStatus = '${rawStatus[0].toUpperCase()}${rawStatus.substring(1).toLowerCase()}';
    }

    return ReportModel(
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? 'No Description',
      location: json['location_address']?.toString() ?? 'No Location',
      number: json['id']?.toString() ?? '#000000',
      status: rawStatus,
    );
  }
}

class TrackReportScreen extends StatefulWidget {
  static const String routeName = "track_report";

  const TrackReportScreen({super.key});

  @override
  State<TrackReportScreen> createState() => _TrackReportScreenState();
}

class _TrackReportScreenState extends State<TrackReportScreen> {
  List<ReportModel> _allReports = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchReports() async {
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
        final List<dynamic> data = decodedData['data'] ?? [];

        if (mounted) {
          setState(() {
            _allReports = data.map((json) => ReportModel.fromJson(json)).toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedData['message'] ?? 'Failed to load reports')),
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

  List<ReportModel> get _filteredReports {
    return _allReports.where((report) {
      final matchesFilter = _selectedFilter == 'All' || report.status == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          report.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Widget _buildBottomNavigationBar() {
    return const NavigationBarr(currentIndex: 2);
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
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Track Number or Title',
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredReports.isEmpty
                    ? const Center(
                        child: Text(
                          'No reports found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
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
    switch (status.toLowerCase()) {
      case 'solved':
        return const Color(0xFF27C840);
      case 'in progress':
        return const Color(0xFFFEBC2F);
      case 'cancelled':
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  const StatusBadge({
    super.key,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}