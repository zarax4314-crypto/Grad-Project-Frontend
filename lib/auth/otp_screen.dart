import 'package:flutter/material.dart';
import 'package:grad_project/auth/reset_password_screen.dart';

import '../responsive/responsive_helper.dart';

class OtpScreen extends StatelessWidget {
  static const String routeName = "otp";

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(0.06)),
          child: Column(
            children: [
              SizedBox(height: Responsive.h(0.1)),

              // 🔹 Title
              const Text(
                "OTP",
                style: TextStyle(
                  fontFamily: "PTSerif",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: Responsive.h(0.04)),

              // 🔹 Description
              const Text(
                "Enter 5-digit code sent to your mail",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "PTSerif",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: Responsive.h(0.05)),

              // 🔹 OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: Responsive.w(0.13),
                    height: Responsive.w(0.13),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Color(0xffE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Color(0xffE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Color(0xff2F6FED)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Responsive.h(0.06)),

              // 🔹 Verify Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ResetPasswordScreen.routeName,
                  );
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
                      "Verify",
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