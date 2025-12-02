import 'dart:convert';
import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';

class RemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  // Authentication methods
  Future<Map<String, dynamic>> signIn(String username, String password) async {
    final response = await _apiClient.post(
      ApiConfig.loginEndpoint,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Store the token
      await _apiClient.setAuthToken(data['token']);
      
      return {
        'user': UserModel.fromJson(data['user']),
        'token': data['token'],
      };
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['non_field_errors']?.first ?? 'Sign in failed');
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.signupEndpoint,
      body: {
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      // Store the token
      await _apiClient.setAuthToken(data['token']);
      
      return {
        'user': UserModel.fromJson(data['user']),
        'token': data['token'],
      };
    } else {
      final errorData = jsonDecode(response.body);
      String errorMessage = 'Sign up failed';
      
      if (errorData['details'] != null) {
        final details = errorData['details'];
        if (details['username'] != null) {
          errorMessage = details['username'].first;
        } else if (details['email'] != null) {
          errorMessage = details['email'].first;
        } else if (details['password'] != null) {
          errorMessage = details['password'].first;
        }
      }
      
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async {
    await _apiClient.post(ApiConfig.logoutEndpoint);
    await _apiClient.setAuthToken(null);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.currentUserEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to get current user');
    }
  }

  // Content methods
  Future<List<ContentModel>> getRecentContent() async {
    final response = await _apiClient.get(ApiConfig.recentContentEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      
      return results
          .map((json) => ContentModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load recent content');
    }
  }

  Future<List<ContentModel>> getLiveContent() async {
    final response = await _apiClient.get(ApiConfig.liveContentEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      
      return results
          .map((json) => ContentModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load live content');
    }
  }

  Future<List<ContentModel>> getContent({
    String? type,
    String? category,
    String? search,
  }) async {
    String endpoint = ApiConfig.contentEndpoint;
    List<String> queryParams = [];
    
    if (type != null) queryParams.add('type=$type');
    if (category != null) queryParams.add('category=$category');
    if (search != null) queryParams.add('search=$search');
    
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await _apiClient.get(endpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      
      return results
          .map((json) => ContentModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load content');
    }
  }

  // Event methods
  Future<List<EventModel>> getUpcomingEvents() async {
    final response = await _apiClient.get(ApiConfig.upcomingEventsEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      
      return results
          .map((json) => EventModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load upcoming events');
    }
  }

  Future<List<EventModel>> getEvents() async {
    final response = await _apiClient.get(ApiConfig.eventsEndpoint);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      
      return results
          .map((json) => EventModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}