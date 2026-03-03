import 'package:flutter/material.dart';
import 'package:grad_project/success.dart';

class ReviewSubmitScreen extends StatelessWidget {
  static const String routeName = "review_report";

  const ReviewSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Base design width for responsiveness
    const double designWidth = 375.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / designWidth;

    // Shadow configuration as per CSS:
    // box-shadow: 0px 2px 6px 2px #00000026; (26 hex = 0.15 opacity)
    // box-shadow: 0px 1px 2px 0px #0000004D; (4D hex = 0.30 opacity)
    final List<BoxShadow> cardShadows = [
      BoxShadow(
        color: const Color(0x26000000),
        offset: const Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: const Color(0x4D000000),
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review & Submit Report',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 10 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Card: Photo
            _buildSectionTitle('Photo', scale),
            _buildCard(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12 * scale),
                child: Image.asset(
                  'assets/images/photo.png', // Placeholder matching the question mark aesthetic
                  fit: BoxFit.contain,

                ),
              ),
              shadows: cardShadows,
              scale: scale,
            ),
            SizedBox(height: 20 * scale),

            // Second Card: Describe Problem
            _buildSectionTitle('Describe Problem', scale),
            _buildCard(
              child: Container(
                padding: EdgeInsets.all(12 * scale),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Text(
                  'Lorem ipsum dolor sit amet consectetur. Odio risus in tortor fermentum habitasse. Sed fermentum aenean erat ipsum facilisis ultrices porttitor. Egestas pharetra morbi tristique consectetur blandit eu dolor. Tellus suscipit rhoncus scelerisque in gravida gravida massa.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14 * scale,
                    height: 1.5,
                  ),
                ),
              ),
              shadows: cardShadows,
              scale: scale,
            ),
            SizedBox(height: 20 * scale),

            // Third Card: Type
            _buildSectionTitle('Type', scale),
            _buildCard(
              child: Row(
                children: [
                  _buildPill('Roads', isSelected: true, scale: scale),
                  SizedBox(width: 10 * scale),
                  _buildPill('Lights', isSelected: false, scale: scale),
                  SizedBox(width: 10 * scale),
                  _buildPill('Clean', isSelected: false, scale: scale),
                ],
              ),
              shadows: cardShadows,
              scale: scale,
            ),
            SizedBox(height: 20 * scale),

            // Date Field
            _buildLabel('Date', scale),
            _buildDisabledInput('2/10/2025', scale),
            SizedBox(height: 20 * scale),

            // Location Field
            _buildLabel('Location', scale),
            _buildDisabledInput('Port Said, Port Fouad City, Port Said Governorate', scale),
            SizedBox(height: 20 * scale),

            // Priority Card
            _buildSectionTitle('Priority', scale),
            _buildCard(
              child: Row(
                children: [
                  _buildPill('High', isSelected: true, scale: scale),
                ],
              ),
              shadows: cardShadows,
              scale: scale,
            ),
            SizedBox(height: 30 * scale),

            // Bottom Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16 * scale),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                    ),
                    child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 15 * scale),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF245FF6), Color(0xFF5EC4FA)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    child: ElevatedButton(
                      onPressed: () {Navigator.pushNamed(
                        context,
                        ReportsubmittedScreen.routeName,
                      );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 16 * scale),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scale),
                        ),
                      ),
                      child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20 * scale),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double scale) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8 * scale, left: 4 * scale),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16 * scale,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildLabel(String label, double scale) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8 * scale, left: 4 * scale),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14 * scale,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, required List<BoxShadow> shadows, required double scale}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  Widget _buildPill(String text, {required bool isSelected, required double scale}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 8 * scale),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFD9F3FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14 * scale,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDisabledInput(String text, double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 14 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14 * scale,
        ),
      ),
    );
  }
}
