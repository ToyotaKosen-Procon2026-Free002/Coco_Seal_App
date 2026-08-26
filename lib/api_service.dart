import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = "https://coco-seal.mydns.jp";

  static Future<Map<String, String>> _getHeaders() async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (idToken != null) 'Authorization': 'Bearer $idToken',
    };
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    final url = Uri.parse('$baseUrl/users/me');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // UTF-8でデコードして文字化けを防止
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}