import 'package:flutter_user/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenManager {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _role;
  static String? _userEmail;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _role = prefs.getString('user_role');
    _userEmail = prefs.getString('user_email');
  }

  // Save tokens after login/signup
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _role = role;
    _userEmail = email;

    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('user_role', role);
    await prefs.setString('user_email', email);
  }

  static Future<void> logout() async {
    // Call logout API first (if we have tokens)
    if (_refreshToken != null && _userEmail != null) {
      try {
        await http.post(
          Uri.parse('$url/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _userEmail,
            'refreshToken': _refreshToken,
          }),
        );
      } catch (e) {
        print('Logout API call failed: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_role');
    await prefs.remove('user_email');

    _accessToken = null;
    _refreshToken = null;
    _role = null;
    _userEmail = null;
  }

  static Future<String?> getValidAccessToken() async {    
    if (_accessToken == null) {
      return null;
    }

    if (!isTokenExpired(_accessToken!)) {
      return _accessToken;
    }

    return await refreshAccessToken();
  }

  // Refresh access token using refresh token
  static Future<String?> refreshAccessToken() async {
    
    if (_refreshToken == null) {
      return null;
    }

    try {
   
      final response = await http.post(
        Uri.parse('${url}auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': _refreshToken}),
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newAccessToken = data['token'] ?? data['accessToken'];
        final newRefreshToken = data['refreshToken'] ?? _refreshToken!;
        final userRole = data['role'] ?? _role!;
        final userEmail = data['email'] ?? _userEmail!;

        await saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          role: userRole,
          email: userEmail,
        );
        return _accessToken;
      } else {
        await logout();
        return null;
      }
    } catch (e) {
      await logout();
      return null;
    }
  }

  // Check if a token is expired
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true;
      }

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) {
        return true;
      }

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final isExpired = expiryDate.isBefore(now);    
      return isExpired;
    } catch (e) {
      return true;
    }
  }

  static String? get role => _role;
  static String? get userEmail => _userEmail;
  static String? get refreshToken => _refreshToken;
  static String? get token => _accessToken;

  static bool get isLoggedIn =>
      _refreshToken != null && !isTokenExpired(_refreshToken!);

  static Future<String?> forceRefresh() async {
    return await refreshAccessToken();
  }
}
