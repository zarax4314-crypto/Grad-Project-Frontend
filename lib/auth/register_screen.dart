import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../responsive/responsive_helper.dart';
import 'login_screen.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ApiService.baseUrl}/auth/register/');

    Map<String, dynamic> requestBody = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text,
    };

    if (_emailController.text.trim().isNotEmpty) {
      requestBody["email"] = _emailController.text.trim();
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 &&
          (responseData['code'] == 200 || responseData['code'] == 201)) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Registration failed')),
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
    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(0.06)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Responsive.h(0.08)),
                Image.asset(
                  "assets/images/Frame13.png",
                  width: Responsive.w(0.35),
                  height: Responsive.h(0.14),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: Responsive.h(0.02)),
                const Text(
                  "Create a new account",
                  style: TextStyle(
                    fontFamily: "PTSerif",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Responsive.h(0.005)),
                const Text(
                  "Join us today",
                  style: TextStyle(
                    fontFamily: "PTSerif",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff6B7280),
                  ),
                ),
                SizedBox(height: Responsive.h(0.05)),
                fieldLabel("Full name"),
                customField(
                  hint: "Enter your name",
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.02)),
                fieldLabel("Email (Optional)"),
                customField(
                  hint: "example@email.com",
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.02)),
                fieldLabel("Mobile number"),
                customField(
                  hint: "01xxxxxxxxx",
                  icon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.02)),
                fieldLabel("Password"),
                customField(
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 6) return 'Must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.02)),
                fieldLabel("Confirm Password"),
                customField(
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.04)),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        },
                  child: Container(
                    height: Responsive.h(0.065),
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
                              "Create account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.03)),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: Responsive.h(0.03)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon("assets/images/Facebook-f_Logo-Blue-Logo.wine.png"),
                    SizedBox(width: Responsive.w(0.04)),
                    socialIcon("assets/images/google.png"),
                    SizedBox(width: Responsive.w(0.04)),
                    socialIcon("assets/images/apple.png"),
                  ],
                ),
                SizedBox(height: Responsive.h(0.03)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Color(0xff2F6FED),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(0.04)),
                const Text(
                  "Privacy Policy  |  Terms and Conditions",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: Responsive.h(0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget fieldLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xff374151),
        ),
      ),
    );
  }

  static Widget customField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: Responsive.h(0.008)),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
    );
  }

  static Widget socialIcon(String path) {
    return Container(
      width: Responsive.w(0.12),
      height: Responsive.w(0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Center(
        child: Image.asset(
          path,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}