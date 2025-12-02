import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_data_source.dart';
import '../../core/network/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final ApiClient _apiClient = ApiClient();

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signIn(String username, String password) async {
    try {
      final result = await remoteDataSource.signIn(username, password);
      return result['user'];
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<User> signUp({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        confirmPassword: confirmPassword,
      );
      return result['user'];
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _apiClient.authToken != null;
  }
}