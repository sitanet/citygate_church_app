class ApiConfig {
  // Update this to match your Django backend URL
  static const String baseUrl = 'http://192.168.43.57:8000'; // Update with your actual backend URL
  static const String apiBaseUrl = '$baseUrl/api';
  
  // API Endpoints
  static const String loginEndpoint = '$apiBaseUrl/auth/login/';
  static const String signupEndpoint = '$apiBaseUrl/auth/signup/';
  static const String logoutEndpoint = '$apiBaseUrl/auth/logout/';
  static const String currentUserEndpoint = '$apiBaseUrl/auth/current-user/';
  
  static const String contentEndpoint = '$apiBaseUrl/content/';
  static const String recentContentEndpoint = '$apiBaseUrl/content/recent/';
  static const String liveContentEndpoint = '$apiBaseUrl/content/live/';
  
  static const String eventsEndpoint = '$apiBaseUrl/events/';
  static const String upcomingEventsEndpoint = '$apiBaseUrl/events/upcoming/';
  
  static const String categoriesEndpoint = '$apiBaseUrl/categories/';
  static const String bannersEndpoint = '$apiBaseUrl/banners/';
  static const String statisticsEndpoint = '$apiBaseUrl/statistics/';
  
  // Request timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}