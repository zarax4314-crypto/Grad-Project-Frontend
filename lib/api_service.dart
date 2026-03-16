import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String baseUrl = "https://achenial-nereida-unvelvety.ngrok-free.dev";
  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final url = Uri.parse('$baseUrl/auth/login/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "password": password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/auth/register/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String phone) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "otp": otp}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(String phone, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/forget-password/confirm/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "otp": otp,
          "new_password": newPassword
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> getRecentReports() async {
    final url = Uri.parse('$baseUrl/complaints/');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> trackReports() async {
    final url = Uri.parse('$baseUrl/complaints/');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> getReportDetails(String reportId) async {
    final url = Uri.parse('$baseUrl/complaints/$reportId/');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> createReport({
    required String title,
    required String description,
    required String date,
    required String locationAddress,
    required String priority,
    required String category,
    required String latitude,
    required String longitude,
    required List<File> images,
  }) async {
    final url = Uri.parse('$baseUrl/complaints/');
    try {
      var request = http.MultipartRequest('POST', url);
      
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['date'] = date;
      request.fields['location_address'] = locationAddress;
      request.fields['priority'] = priority;
      request.fields['category'] = category;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;

      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath('media', image.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> getProfileData() async {
    final url = Uri.parse('$baseUrl/profile/');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/profile/');
    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/reset-password/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"old_password": oldPassword, "new_password": newPassword}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }

  static Future<Map<String, dynamic>> getNotifications() async {
    final url = Uri.parse('$baseUrl/notifications/');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    } catch (e) {
      return {"code": 500, "message": "Network Error"};
    }
  }
}