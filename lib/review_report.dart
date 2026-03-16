import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';
import 'package:grad_project/success.dart';
import 'colors.dart';

class ReviewSubmitScreen extends StatefulWidget {
  static const String routeName = "review_report";

  const ReviewSubmitScreen({super.key});

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  bool _isSubmitting = false;

  Future<void> _submitReport(Map<String, dynamic> reportData) async {
    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('${ApiService.baseUrl}/complaints/');

    try {
      var request = http.MultipartRequest('POST', url);
      
      request.fields['title'] = reportData['title'] ?? 'New Report'; // الحقل ده مطلوب في الباك إند
      request.fields['description'] = reportData['description'] ?? '';
      request.fields['date'] = reportData['date'] ?? '';
      request.fields['location_address'] = reportData['location'] ?? ''; // تغيير الاسم لـ location_address
      request.fields['priority'] = reportData['priority'] ?? 'Low';
      request.fields['category'] = (reportData['types'] as List).isNotEmpty 
          ? reportData['types'][0] 
          : 'General'; 
          
      request.fields['latitude'] = reportData['latitude']?.toString() ?? "31.435658";
      request.fields['longitude'] = reportData['longitude']?.toString() ?? "31.674627";

      List<File> images = reportData['images'] ?? [];
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath('media', image.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            ReportsubmittedScreen.routeName,
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error occurred')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    
    final String description = args['description'] ?? 'No description provided';
    final String date = args['date'] ?? 'N/A';
    final String location = args['location'] ?? 'N/A';
    final String priority = args['priority'] ?? 'Low';
    final List<String> types = args['types'] ?? [];
    final List<File> images = args['images'] ?? [];

    const double designWidth = 375.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / designWidth;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review & Submit',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 10 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Photo', scale),
            _buildCard(
              child: images.isNotEmpty 
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(images[0], fit: BoxFit.cover, height: 200 * scale, width: double.infinity),
                  )
                : const Center(child: Text("No Photo Selected")),
              scale: scale,
            ),
            SizedBox(height: 20 * scale),

            _buildSectionTitle('Description', scale),
            _buildCard(
              child: Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 14 * scale)),
              scale: scale,
            ),
            SizedBox(height: 20 * scale),

            _buildSectionTitle('Category', scale),
            Wrap(
              spacing: 8,
              children: types.map((t) => _buildPill(t, scale: scale)).toList(),
            ),
            SizedBox(height: 20 * scale),

            _buildLabel('Date', scale),
            _buildDisabledInput(date, scale),
            SizedBox(height: 15 * scale),

            _buildLabel('Location', scale),
            _buildDisabledInput(location, scale),
            SizedBox(height: 15 * scale),

            _buildLabel('Priority', scale),
            _buildPill(priority, scale: scale, color: const Color(0xFFD9F3FF)),

            SizedBox(height: 40 * scale),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Edit', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : () => _submitReport(args),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isSubmitting 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double scale) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.bold)),
  );

  Widget _buildLabel(String label, double scale) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(label, style: TextStyle(fontSize: 14 * scale, color: Colors.black54)),
  );

  Widget _buildCard({required Widget child, required double scale}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  Widget _buildPill(String text, {required double scale, Color color = const Color(0xFFE0E0E0)}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  );

  Widget _buildDisabledInput(String text, double scale) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Text(text, style: const TextStyle(color: Colors.black87)),
  );
}