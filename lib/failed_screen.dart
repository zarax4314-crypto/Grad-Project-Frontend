import 'package:flutter/material.dart';

class ReportUnsubmittedScreen extends StatelessWidget {
  static const String routeName = "failed";

  const ReportUnsubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F7FA),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Review & Submit Report",
          style: TextStyle(
            fontFamily: 'PTSerif',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Image
              Image.asset(
                "assets/images/failed.png",
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 49),

              /// Title
              const Text(
                "Report Unsubmitted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 49),

              /// Gradient Button
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
                        Color(0xFF245FF6),
                        Color(0xFF5EC4FA),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}