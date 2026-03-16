import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../responsive/responsive_helper.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "forgot";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ApiService.baseUrl}/auth/forget-password/');
    final identifier = _identifierController.text.trim();

    Map<String, dynamic> requestBody = {
      "phone": identifier,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          (responseData['code'] == 200 || responseData['code'] == 201)) {
        if (mounted) {
          Navigator.pushNamed(context, OtpScreen.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to send OTP')),
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
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(0.06)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Responsive.h(0.1)),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontFamily: "PTSerif",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Responsive.h(0.04)),
                SizedBox(
                  width: Responsive.w(0.85),
                  child: const Text(
                    "Enter your mobile number to receive an OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "PTSerif",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.1)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mobile number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff374151),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.01)),
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "01xxxxxxxxx",
                    suffixIcon: const Icon(
                      Icons.phone_outlined,
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: const BorderSide(color: Color(0xff2F6FED)),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.04)),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            sendOtp();
                          }
                        },
                  child: Container(
                    height: Responsive.h(0.065),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff2F6FED),
                          Color(0xff56CCF2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}