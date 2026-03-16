import 'package:flutter/material.dart';
import 'package:grad_project/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home/home_screen.dart';
import '../responsive/responsive_helper.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "ll";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

  Future<void> loginUser(String identifier, String password) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ApiService.baseUrl}/auth/login/');
    
    Map<String, dynamic> requestBody = {
      "phone": identifier,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && 
         (responseData['code'] == 200 || responseData.containsKey('id'))) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Login failed. Please check your credentials.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error occurred. Please check your connection.')),
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
                  "Welcome",
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
                  "Log in to continue",
                  style: TextStyle(
                    fontFamily: "PTSerif",
                    fontSize: 14,
                    color: Color(0xff6B7280),
                  ),
                ),
                SizedBox(height: Responsive.h(0.05)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email or mobile number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff374151),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.008)),
                customField(
                  hint: "example@email.com or phone",
                  icon: Icons.person_outline,
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.02)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff374151),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.008)),
                customField(
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: _isObscure,
                  controller: _passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Responsive.h(0.04)),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            loginUser(
                              _identifierController.text,
                              _passwordController.text,
                            );
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
                              "Log in",
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ForgotPasswordScreen.routeName,
                    );
                  },
                  child: const Text(
                    "Forgot your password?",
                    style: TextStyle(
                      color: Color(0xff2F6FED),
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(0.015)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RegisterScreen.routeName,
                        );
                      },
                      child: const Text(
                        "Register now",
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

  static Widget customField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffixIcon,
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
    );
  }

  static Widget socialIcon(String path) {
    return Container(
      width: 48,
      height: 48,
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