import 'package:flutter/material.dart';
import '../responsive/responsive_helper.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = "forgot";

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(0.06)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Responsive.h(0.1)),

              // 🔹 Title
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

              // 🔹 Description
              SizedBox(
                width: Responsive.w(0.85),
                child: const Text(
                  "Enter E-mail or mobile number to send OTP",
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

              // 🔹 Label
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

              SizedBox(height: Responsive.h(0.01)),

              // 🔹 Input
              TextField(
                decoration: InputDecoration(
                  hintText: "example@email.com",
                  suffixIcon: const Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide:
                    const BorderSide(color: Color(0xffE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide:
                    const BorderSide(color: Color(0xffE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide:
                    const BorderSide(color: Color(0xff2F6FED)),
                  ),
                ),
              ),

              SizedBox(height: Responsive.h(0.04)),

              // 🔹 Continue Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, OtpScreen.routeName);
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
                  child: const Center(
                    child: Text(
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
    );
  }
}