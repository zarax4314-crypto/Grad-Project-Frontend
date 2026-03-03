import 'package:flutter/material.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = "reset";

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  String? newPasswordError;
  String? repeatPasswordError;

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void onReset() {
    final newPass = newPasswordController.text.trim();
    final repeatPass = repeatPasswordController.text.trim();

    bool valid = true;

    setState(() {
      newPasswordError = null;
      repeatPasswordError = null;

      // تحقق من الباسورد
      if (!isValidPassword(newPass)) {
        newPasswordError =
        'Password must be at least 8 characters, include a number and an uppercase letter.';
        valid = false;
      }

      // تحقق من التطابق
      if (newPass != repeatPass) {
        repeatPasswordError = 'Passwords do not match.';
        valid = false;
      }
    });

    if (valid) {
      // نجاح -> العودة للوجين
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),

              const Text(
                "Reset Password",
                style: TextStyle(
                  fontFamily: "PTSerif",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 60),

              // 🔹 New Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Password",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff374151),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                obscuringCharacter: '●',
                decoration: InputDecoration(
                  hintText: '●●●●●●●●',
                  hintStyle: const TextStyle(
                    letterSpacing: 4,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  errorText: newPasswordError,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Repeat Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Repeat Password",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff374151),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: repeatPasswordController,
                obscureText: true,
                obscuringCharacter: '●',
                decoration: InputDecoration(
                  hintText: '●●●●●●●●',
                  hintStyle: const TextStyle(
                    letterSpacing: 4,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  errorText: repeatPasswordError,
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: onReset,
                child: Container(
                  height: 52,
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
                  child: const Center(
                    child: Text(
                      "Reset",
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
    );
  }
}
