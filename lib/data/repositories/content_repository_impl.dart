import '../../domain/entities/content.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/remote_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  final RemoteDataSource remoteDataSource;

  ContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Content>> getRecentContent() async {
    try {
      return await remoteDataSource.getRecentContent();
    } catch (e) {
      throw Exception('Failed to get recent content: ${e.toString()}');
    }
  }

  @override
  Future<List<Content>> getLiveContent() async {
    try {
      return await remoteDataSource.getLiveContent();
    } catch (e) {
      throw Exception('Failed to get live content: ${e.toString()}');
    }
  }

  @override
  Future<List<Content>> getContent({
    String? type,
    String? category,
    String? search,
  }) async {
    try {
      return await remoteDataSource.getContent(
        type: type,
        category: category,
        search: search,
      );
    } catch (e) {
      throw Exception('Failed to get content: ${e.toString()}');
    }
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    try {
      return await remoteDataSource.getUpcomingEvents();
    } catch (e) {
      throw Exception('Failed to get upcoming events: ${e.toString()}');
    }
  }

  @override
  Future<List<Event>> getEvents() async {
    try {
      return await remoteDataSource.getEvents();
    } catch (e) {
      throw Exception('Failed to get events: ${e.toString()}');
    }
  }
}