import 'package:grad_project/home/home_screen.dart';
import 'package:grad_project/auth/login_screen.dart';
import 'package:grad_project/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/profile/change_password.dart';
import 'package:grad_project/profile/edit_personal_information_screen.dart';
import 'package:grad_project/profile/notification.dart';
import 'package:grad_project/profile/profile_screen.dart';
import 'package:grad_project/review_report.dart';
import 'package:grad_project/success.dart';
import 'package:grad_project/track_report/track_report.dart';
import 'package:grad_project/track_report/track_report2.dart';
import 'auth/forgot_password_screen.dart';
import 'auth/otp_screen.dart';
import 'auth/reset_password_screen.dart';
import 'failed_screen.dart';
import 'map_screen.dart';
import 'new_report/new_report_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: "PTSerif",),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        OtpScreen.routeName: (context) => const OtpScreen(),
        ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
        MapScreen.routeName: (_) => const MapScreen(),
        NewReportScreen.routeName: (_) => const NewReportScreen(),
        ReportUnsubmittedScreen.routeName: (_) => const ReportUnsubmittedScreen(),
        ReportsubmittedScreen.routeName: (_) => const ReportsubmittedScreen(),
        ReviewSubmitScreen.routeName: (_) => const ReviewSubmitScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        EditPersonalInformationScreen.routeName: (_) => const EditPersonalInformationScreen(),
        TrackReportScreen.routeName: (_) => const TrackReportScreen(),
        TrackReporttScreen.routeName: (_) => const TrackReporttScreen(),
        NotificationScreen.routeName: (_) => const NotificationScreen(),
        ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),


      },




    );
  }
}
