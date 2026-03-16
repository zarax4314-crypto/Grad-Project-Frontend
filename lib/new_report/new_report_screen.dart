import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../navigation_bar.dart';
import '../review_report.dart';

class NewReportScreen extends StatefulWidget {
  static const String routeName = "new_report";

  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<File> _selectedImages = [];
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> _selectedTypes = [];
  String _selectedPriority = '';

  final List<String> _reportTypes = ['Roads', 'Lights', 'Clean', 'Other'];
  final List<String> _priorities = ['Low', 'Intermediate', 'High'];

  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 4) return;

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF245FF6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> submitReport() async {
    if (_problemController.text.isEmpty || _selectedTypes.isEmpty || _selectedPriority.isEmpty || _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/complaints/'),
      );

      request.fields['title'] = _problemController.text.length > 20 
          ? _problemController.text.substring(0, 20) 
          : _problemController.text;
      request.fields['description'] = _problemController.text;
      request.fields['date'] = _dateController.text;
      request.fields['location_address'] = _locationController.text.isNotEmpty ? _locationController.text : "Unknown location";
      request.fields['priority'] = _selectedPriority.toLowerCase();
      
      int categoryId = 1; 
      if (_selectedTypes.contains('Roads')) categoryId = 2;
      if (_selectedTypes.contains('Lights')) categoryId = 3;
      if (_selectedTypes.contains('Clean')) categoryId = 4;
      request.fields['category'] = categoryId.toString();

      request.fields['latitude'] = "31.435658";
      request.fields['longitude'] = "31.674627";

      for (int i = 0; i < _selectedImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'media', 
            _selectedImages[i].path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && 
         (responseData['code'] == 200 || responseData['code'] == 201)) {
        if (mounted) {
          Navigator.pushNamed(context, ReviewSubmitScreen.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to submit report')),
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Report',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? size.width * 0.1 : 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: 'Add Photo',
              child: Row(
                children: [
                  Expanded(
                    child: _buildImageSourceButton(
                      label: 'Gallery',
                      icon: Icons.add_photo_alternate_outlined,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageSourceButton(
                      label: 'Camera',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                ],
              ),
              previewWidget: _selectedImages.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          _selectedImages.length,
                          (index) => Stack(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(_selectedImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close,
                                        size: 14, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Describe Problem',
              child: TextField(
                controller: _problemController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Problem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Type',
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedTypes.contains(type);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSelectableChip(
                        label: type,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTypes.remove(type);
                            } else {
                              _selectedTypes.add(type);
                            }
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            _buildReadOnlyField(
              controller: _dateController,
              hint: '/  /  /',
              suffixIcon: Icons.calendar_today_outlined,
              onTap: _selectDate,
            ),
            const SizedBox(height: 20),
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            _buildReadOnlyField(
              controller: _locationController,
              hint: 'Enter address manually',
              suffixIcon: Icons.location_on,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Priority',
              child: Row(
                children: _priorities.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSelectableChip(
                        label: priority,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarr(currentIndex: 0),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    Widget? previewWidget,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 20),
          child,
          if (previewWidget != null) previewWidget,
        ],
      ),
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x3300C0E8) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFF0F0F0),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF707070), size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF909090), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required TextEditingController controller,
    required String hint,
    required IconData suffixIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: controller.text.isEmpty
                  ? Text(
                      hint,
                      style: const TextStyle(
                        color: Color(0xFFD0D0D0),
                        fontSize: 16,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
            ),
            Icon(suffixIcon, color: const Color(0xFFB0B0B0), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF245FF6), Color(0xFF5EC4FA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Review & Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}