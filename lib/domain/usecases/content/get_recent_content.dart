import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/content.dart';
import '../../repositories/content_repository.dart';

class GetRecentContent implements UseCase<List<Content>, NoParams> {
  final ContentRepository repository;

  GetRecentContent(this.repository);

  @override
  Future<Either<Failure, List<Content>>> call(NoParams params) async {
    return await repository.getRecentContent();
  }
}