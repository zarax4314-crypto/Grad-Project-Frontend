import 'package:flutter/material.dart';
import '../responsive/responsive_helper.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "register";

  const RegisterScreen({super.key});

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
              SizedBox(height: Responsive.h(0.08)),

              // 🔹 Logo
              Image.asset(
                "assets/images/Frame13.png",
                width: Responsive.w(0.35),
                height: Responsive.h(0.14),
                fit: BoxFit.contain,
              ),

              SizedBox(height: Responsive.h(0.02)),

              // 🔹 Title
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

              // 🔹 Full Name
              fieldLabel("Full name"),
              customField(
                hint: "Enter your name",
                icon: Icons.person_outline,
              ),

              SizedBox(height: Responsive.h(0.02)),

              // 🔹 Email
              fieldLabel("Email or mobile number"),
              customField(
                hint: "example@email.com",
                icon: Icons.mail_outline,
              ),

              SizedBox(height: Responsive.h(0.02)),

              // 🔹 Phone
              fieldLabel("Email or mobile number"),
              customField(
                hint: "20xxxxxxxxx",
                icon: Icons.phone_outlined,
              ),

              SizedBox(height: Responsive.h(0.02)),

              // 🔹 Password
              fieldLabel("Password"),
              customField(
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: Responsive.h(0.02)),

              // 🔹 Confirm Password
              fieldLabel("Confirm Password"),
              customField(
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: Responsive.h(0.04)),

              // 🔹 Create Account Button
              Container(
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
                child: const Center(
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Responsive.h(0.03)),

              // 🔹 OR
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

              // 🔹 Social Icons
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

              // 🔹 Bottom Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
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
    );
  }

  // 🔹 Label
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

  // 🔹 Input Field
  static Widget customField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: Responsive.h(0.008)),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
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
        ),
      ),
    );
  }

  // 🔹 Social Icon
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