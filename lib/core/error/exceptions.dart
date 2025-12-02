// Base exception class for API errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => message;
}

// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

// Authentication related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

// Server related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;
  
  const ValidationException(super.message, {super.code, this.fieldErrors});
}

// Cache related exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}