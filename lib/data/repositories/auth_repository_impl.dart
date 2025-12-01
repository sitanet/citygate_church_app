import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await MockDataSource.mockSignIn(email, password);
      return Right(user);
    } catch (e) {
      return const Left(AuthFailure('Invalid credentials'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String name, String email, String password) async {
    try {
      // Mock sign up implementation
      await Future.delayed(const Duration(seconds: 1));
      return const Right(UserModel(
        id: '2',
        name: 'New User',
        email: 'newuser@email.com',
        isOnline: true,
      ));
    } catch (e) {
      return const Left(AuthFailure('Sign up failed'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure('Sign out failed'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Mock getting current user from storage
      await Future.delayed(const Duration(milliseconds: 200));
      return const Right(null); // No user stored
    } catch (e) {
      return const Left(AuthFailure('Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure('Failed to send password reset email'));
    }
  }
}