import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/usecase/usecase.dart';

class SignInParams {
  final String username;
  final String password;

  SignInParams({required this.username, required this.password});
}

class SignIn implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<User> call(SignInParams params) async {
    return await repository.signIn(params.username, params.password);
  }
}