import '../../repositories/auth_repository.dart';
import '../../../core/usecase/usecase.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.signOut();
  }
}