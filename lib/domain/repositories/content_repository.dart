import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/content.dart';
import '../entities/event.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<Content>>> getRecentContent();
  Future<Either<Failure, List<Event>>> getUpcomingEvents();
  Future<Either<Failure, List<Content>>> searchContent(String query);
  Future<Either<Failure, List<Content>>> getContentByCategory(String category);
  Future<Either<Failure, Content?>> getLiveContent();
}