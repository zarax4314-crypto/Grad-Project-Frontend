import 'package:flutter/material.dart';
import 'colors.dart';

class ReportUnsubmittedScreen extends StatelessWidget {
  static const String routeName = "failed";

  const ReportUnsubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: const SizedBox.shrink(),
        title: const Text(
          "Submission Failed",
          style: TextStyle(
            fontFamily: 'PTSerif',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Failed Image
              Image.asset(
                "assets/images/failed.png",
                fit: BoxFit.contain,
                height: 220, 
              ),

              const SizedBox(height: 40),

              /// Error Title
              const Text(
                "Report Unsubmitted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              /// Error Description
              const Text(
                "Something went wrong while sending your report.\nPlease check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 50),

              /// Retry Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.gradientStart,
                        AppColors.gradientEnd,
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context); 
                      },
                      child: const Center(
                        child: Text(
                          "Try again",
                          style: TextStyle(
                            fontFamily: 'PTSerif',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              /// Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                },
                child: const Text(
                  "Cancel and go Home",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}