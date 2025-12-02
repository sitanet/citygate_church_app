import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/usecase/usecase.dart';

class SignUpParams {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;

  SignUpParams({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
  });
}

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<User> call(SignUpParams params) async {
    return await repository.signUp(
      username: params.username,
      email: params.email,
      firstName: params.firstName,
      lastName: params.lastName,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}