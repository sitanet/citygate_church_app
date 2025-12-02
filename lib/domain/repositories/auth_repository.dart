import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String username, String password);
  Future<User> signUp({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  });
  Future<void> signOut();
  Future<User> getCurrentUser();
  Future<bool> isAuthenticated();
}