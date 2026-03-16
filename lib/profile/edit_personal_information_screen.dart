import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPersonalInformationScreen extends StatefulWidget {
  static const String routeName = "edit";

  const EditPersonalInformationScreen({super.key});

  @override
  State<EditPersonalInformationScreen> createState() => _EditPersonalInformationScreenState();
}

class _EditPersonalInformationScreenState extends State<EditPersonalInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isFetching = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('${ApiService.baseUrl}/profile/');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && decodedData['code'] == 200) {
        final userData = decodedData['data'];
        
        if (mounted && userData != null) {
          setState(() {
            _nameController.text = userData['name']?.toString() ?? '';
            _emailController.text = userData['email']?.toString() ?? '';
            _phoneController.text = userData['phone']?.toString() ?? '';
            _isFetching = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isFetching = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedData['message'] ?? 'Failed to load profile data')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error occurred')),
        );
      }
    }
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isSaving = true;
    });

    final url = Uri.parse('${ApiService.baseUrl}/profile/');

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "phone": _phoneController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && 
         (responseData['code'] == 200 || responseData['code'] == 201)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to update profile')),
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
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit personal information',
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _isFetching
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const _InputLabel(label: 'Name'),
                    const SizedBox(height: 8),
                    _CustomTextField(
                      hintText: 'Momen',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 24),
                    const _InputLabel(label: 'Email'),
                    const SizedBox(height: 8),
                    _CustomTextField(
                      hintText: 'example@email.com',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 24),
                    const _InputLabel(label: 'Phone number'),
                    const SizedBox(height: 8),
                    _CustomTextField(
                      hintText: '01xxxxxxxxx',
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 40),
                    _GradientSaveButton(
                      isLoading: _isSaving,
                      onPressed: _saveUserData,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String label;

  const _InputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF344054),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const _CustomTextField({required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEAECF0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEAECF0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF47A1FF), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class _GradientSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientSaveButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF245FF6),
            Color(0xFF5EC4FA),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAECF0), width: 1)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E90FA),
        unselectedItemColor: const Color(0xFF98A2B3),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Track'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'My Account',
          ),
        ],
      ),
    );
  }
}