import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grad_project/navigation_bar.dart';
import '../../map_screen.dart';

class TrackReporttScreen extends StatefulWidget {
  static const String routeName = "trackk_reportt";

  const TrackReporttScreen({super.key});

  @override
  State<TrackReporttScreen> createState() => _TrackReporttScreenState();
}

class _TrackReporttScreenState extends State<TrackReporttScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _reportDetails;

  @override
  void initState() {
    super.initState();
    _fetchReportDetails();
  }

  Future<void> _fetchReportDetails() async {
    final url = Uri.parse('${ApiService.baseUrl}/complaints/');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          (decodedData['code'] == 200 || decodedData['code'] == 201)) {
        
        Map<String, dynamic> reportData = {};
        
        if (decodedData['data'] is List && decodedData['data'].isNotEmpty) {
          reportData = decodedData['data'].first;
        } else if (decodedData['data'] is Map) {
          reportData = decodedData['data'];
        }

        String rawStatus = reportData['status']?.toString() ?? 'Pending';
        if (rawStatus.toLowerCase() == 'placed') {
          rawStatus = 'In Progress';
        } else if (rawStatus.isNotEmpty) {
          rawStatus = '${rawStatus[0].toUpperCase()}${rawStatus.substring(1).toLowerCase()}';
        }
        reportData['status'] = rawStatus;

        reportData['number'] = reportData['id']?.toString();
        reportData['location'] = reportData['location_address'];
        
        if (reportData['category_name'] != null) {
          reportData['types'] = [reportData['category_name']];
        }

        reportData['timeline'] ??= [
          {'title': 'Report Submitted', 'date': '10/3/2026', 'isActive': true},
          {'title': 'Under Review', 'date': '10/3/2026', 'isActive': true},
          {'title': 'In Progress', 'date': '11/3/2026', 'isActive': false},
          {'title': 'Solved', 'date': 'Pending', 'isActive': false},
        ];

        if (mounted) {
          setState(() {
            _reportDetails = reportData;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedData['message'] ?? 'Failed to load report details')),
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final String reportNumber = _reportDetails?['number'] ?? '#000000';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Track Report $reportNumber',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressSection(),
                  const SizedBox(height: 24),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildPhotoSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Describe Problem'),
                  const SizedBox(height: 12),
                  _buildProblemDescription(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Type'),
                  const SizedBox(height: 12),
                  _buildTypesSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Date'),
                  const SizedBox(height: 12),
                  _buildReadOnlyField(_reportDetails?['created_at']?.toString().substring(0, 10) ?? 'N/A'),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Location'),
                  const SizedBox(height: 12),
                  _buildReadOnlyField(_reportDetails?['location'] ?? 'N/A'),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Priority'),
                  const SizedBox(height: 12),
                  _buildPriorityBadge(_reportDetails?['priority'] ?? 'Low'),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Location on map'),
                  const SizedBox(height: 12),
                  _buildMapSection(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProgressSection() {
    final String status = _reportDetails?['status'] ?? 'Unknown';
    final String number = _reportDetails?['number'] ?? '#000000';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB300).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final List<dynamic> timeline = _reportDetails?['timeline'] ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 24),
          if (timeline.isEmpty)
            const Text('No status updates available.', style: TextStyle(color: Colors.grey))
          else
            ...List.generate(timeline.length, (index) {
              final item = timeline[index];
              final isLast = index == timeline.length - 1;
              return _buildStatusItem(
                item['title'] ?? '',
                item['date'] ?? '',
                item['isActive'] == true ? const Color(0xFF4CAF50) : Colors.grey.withOpacity(0.4),
                item['isActive'] == true,
                !isLast,
                isFaded: item['isActive'] != true,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
      String title, String date, Color color, bool isActive, bool showLine,
      {bool isFaded = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: isActive
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isFaded ? Colors.grey.withOpacity(0.5) : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: isFaded ? Colors.grey.withOpacity(0.4) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    final String? photoUrl = _reportDetails?['photo_url'];

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      )
                    : Image.asset(
                        'assets/images/photo.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Serif',
      ),
    );
  }

  Widget _buildProblemDescription() {
    final String description = _reportDetails?['description'] ?? 'No description provided.';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildTypesSection() {
    final List<dynamic> types = _reportDetails?['types'] ?? [];
    if (types.isEmpty) {
      return const Text('No types specified.', style: TextStyle(color: Colors.grey));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildChip(type.toString()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF006064),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        priority,
        style: const TextStyle(
          color: Color(0xFF006064),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                MapScreen.routeName,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/-122.4194,37.7749,12/600x400?access_token=placeholder',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Map Preview', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMapButton('Zoom'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMapButton('Directions'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return const NavigationBarr(currentIndex: 2);
  }
}