import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'navigation_bar.dart';
import 'colors.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "map";
  final String title;

  const MapScreen({
    super.key,
    this.title = "Map",
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true;
  Set<Marker> _markers = {};
  
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(31.435658, 31.674627), 
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _fetchReportLocations();
  }

  Future<void> _fetchReportLocations() async {
    // التعديل هنا للمسار الصحيح
    final url = Uri.parse('${ApiService.baseUrl}/complaints/');

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> locations = decodedData['data'] ?? [];
        
        if (mounted) {
          setState(() {
            _markers = locations.where((loc) => loc['latitude'] != null && loc['longitude'] != null).map((loc) {
              // تحويل الإحداثيات من String لـ double للتأكيد
              double lat = double.tryParse(loc['latitude'].toString()) ?? 0.0;
              double lng = double.tryParse(loc['longitude'].toString()) ?? 0.0;

              return Marker(
                markerId: MarkerId(loc['id'].toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: loc['location_address'] ?? 'No Address',
                  snippet: 'Status: ${loc['status']}',
                ),
              );
            }).toSet();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.filter_alt_outlined, color: Colors.black),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: false, 
            markers: _markers,
            onMapCreated: (controller) {},
          ),
          
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED).withOpacity(0.95), 
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusButton(text: "Track\n${_markers.length}", color: const Color(0xFF1E88E5)),
                  _buildStatusButton(text: "Solved\n0", color: AppColors.success),
                  _buildStatusButton(text: "Point\n0", color: AppColors.warning),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBarr(currentIndex: 1),
    );
  }

  Widget _buildStatusButton({required String text, required Color color}) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}