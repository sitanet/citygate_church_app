import '../entities/content.dart';
import '../entities/event.dart';

abstract class ContentRepository {
  Future<List<Content>> getRecentContent();
  Future<List<Content>> getLiveContent();
  Future<List<Content>> getContent({
    String? type,
    String? category,
    String? search,
  });
  Future<List<Event>> getUpcomingEvents();
  Future<List<Event>> getEvents();
}