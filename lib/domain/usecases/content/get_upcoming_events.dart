import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/event.dart';
import '../../repositories/content_repository.dart';

class GetUpcomingEvents implements UseCase<List<Event>, NoParams> {
  final ContentRepository repository;

  GetUpcomingEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(NoParams params) async {
    return await repository.getUpcomingEvents();
  }
}