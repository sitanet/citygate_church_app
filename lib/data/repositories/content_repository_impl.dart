import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/content.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/mock_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  @override
  Future<Either<Failure, List<Content>>> getRecentContent() async {
    try {
      final content = await MockDataSource.getMockRecentContent();
      return Right(content);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch recent content'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getUpcomingEvents() async {
    try {
      final events = await MockDataSource.getMockUpcomingEvents();
      return Right(events);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch upcoming events'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> searchContent(String query) async {
    try {
      final allContent = await MockDataSource.getMockRecentContent();
      final filtered = allContent.where((content) =>
          content.title.toLowerCase().contains(query.toLowerCase()) ||
          content.description.toLowerCase().contains(query.toLowerCase())).toList();
      return Right(filtered);
    } catch (e) {
      return const Left(ServerFailure('Failed to search content'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getContentByCategory(String category) async {
    try {
      final allContent = await MockDataSource.getMockRecentContent();
      final filtered = allContent.where((content) =>
          content.category?.name == category).toList();
      return Right(filtered);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch content by category'));
    }
  }

  @override
  Future<Either<Failure, Content?>> getLiveContent() async {
    try {
      final allContent = await MockDataSource.getMockRecentContent();
      final liveContent = allContent.where((content) => content.isLive).toList();
      return Right(liveContent.isNotEmpty ? liveContent.first : null);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch live content'));
    }
  }
}