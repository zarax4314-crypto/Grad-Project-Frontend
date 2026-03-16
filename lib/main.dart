import 'package:flutter/material.dart';
import 'package:grad_project/home/home_screen.dart';
import 'package:grad_project/auth/login_screen.dart';
import 'package:grad_project/auth/register_screen.dart';
import 'package:grad_project/auth/forgot_password_screen.dart';
import 'package:grad_project/auth/otp_screen.dart';
import 'package:grad_project/auth/reset_password_screen.dart';
import 'package:grad_project/profile/change_password.dart';
import 'package:grad_project/profile/edit_personal_information_screen.dart';
import 'package:grad_project/profile/notification.dart';
import 'package:grad_project/profile/profile_screen.dart';
import 'package:grad_project/review_report.dart';
import 'package:grad_project/success.dart';
import 'package:grad_project/track_report/track_report.dart';
import 'package:grad_project/track_report/track_report2.dart';
import 'package:grad_project/failed_screen.dart';
import 'package:grad_project/map_screen.dart';
import 'package:grad_project/new_report/new_report_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grad Project',
      
      theme: ThemeData(
        fontFamily: "PTSerif",
        useMaterial3: true,
        primaryColor: const Color(0xFF245FF6),
      ),

      initialRoute: LoginScreen.routeName,

      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
        OtpScreen.routeName: (context) => const OtpScreen(),
        ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
        
        HomeScreen.routeName: (context) => const HomeScreen(),
        MapScreen.routeName: (context) => const MapScreen(),
        NewReportScreen.routeName: (context) => const NewReportScreen(),
        
        ReviewSubmitScreen.routeName: (context) => const ReviewSubmitScreen(),
        ReportsubmittedScreen.routeName: (context) => const ReportsubmittedScreen(),
        ReportUnsubmittedScreen.routeName: (context) => const ReportUnsubmittedScreen(),
        
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        EditPersonalInformationScreen.routeName: (context) => const EditPersonalInformationScreen(),
        ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
        NotificationScreen.routeName: (context) => const NotificationScreen(),
        
        TrackReportScreen.routeName: (context) => const TrackReportScreen(),
        TrackReporttScreen.routeName: (context) => const TrackReporttScreen(),
      },
    );
  }
}