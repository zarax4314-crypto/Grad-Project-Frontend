import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'navigation_bar.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = "map";

  final String title;

  const MapScreen({
    super.key,
    this.title = "Map",
  });

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(31.435658, 31.674627), // New Damietta
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      /// ===== AppBar =====
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: const Text(
          "Map",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.filter_alt_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),

      /// ===== Body =====
      body: Stack(
        children: [
          /// Google Map
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
          ),

          /// Floating Card
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Color(0x4D000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusButton(
                    text: "Track\n5",
                    color: const Color(0xFF1E88E5),
                  ),
                  _buildStatusButton(
                    text: "Solved\n5",
                    color: const Color(0xFF2ECC71),
                  ),
                  _buildStatusButton(
                    text: "Point\n5",
                    color: const Color(0xFFF4B400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ===== Bottom Nav =====
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildStatusButton({
    required String text,
    required Color color,
  }) {
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

}
Widget _buildBottomNavigationBar() {
  return NavigationBarr(currentIndex: 1,);
}

