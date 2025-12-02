import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _authToken;

  // Initialize with stored token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  // Set authentication token
  Future<void> setAuthToken(String? token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
    } else {
      await prefs.remove('auth_token');
    }
  }

  // Get authentication token
  String? get authToken => _authToken;

  // Get headers with authentication
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Token $_authToken';
    }
    
    return headers;
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: _headers,
      ).timeout(ApiConfig.connectionTimeout);
      
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // POST request
  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.connectionTimeout);
      
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // PUT request
  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse(endpoint),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(ApiConfig.connectionTimeout);
      
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: _headers,
      ).timeout(ApiConfig.connectionTimeout);
      
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}