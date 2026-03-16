import 'package:flutter/material.dart';
import 'package:grad_project/track_report/track_report.dart';
import 'colors.dart'; 

class ReportsubmittedScreen extends StatelessWidget {
  static const String routeName = "success";

  const ReportsubmittedScreen({super.key});

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
          "Success",
          style: TextStyle(
            fontFamily: 'PTSerif',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Success Image
                Image.asset(
                  "assets/images/success.png",
                  fit: BoxFit.contain,
                  height: 250, 
                ),

                const SizedBox(height: 40),

                /// Title
                const Text(
                  "Report Submitted Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PTSerif',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Your report has been received and is being processed by the authorities.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 50),

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
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            TrackReportScreen.routeName,
                            (route) => route.isFirst,
                          );
                        },
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
                
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                  },
                  child: const Text("Back to Home", style: TextStyle(color: Colors.black54)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}