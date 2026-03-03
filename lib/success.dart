import 'package:flutter/material.dart';
import 'package:grad_project/track_report/track_report.dart';

class ReportsubmittedScreen extends StatelessWidget {
  static const String routeName = "success";

  const ReportsubmittedScreen({super.key});

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
                "assets/images/success.png",
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 49),

              /// Title
              const Text(
                "Report submitted",
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
                      onTap: () {Navigator.pushNamed(
                        context,
                        TrackReportScreen.routeName,
                      );},
                      child: const Center(
                        child: Text(
                          "Track Report",
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