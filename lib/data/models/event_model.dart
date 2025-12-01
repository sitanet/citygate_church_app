import '../../core/constants/app_constants.dart';
import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    super.thumbnailUrl,
    required super.dateTime,
    super.isLive,
    super.category,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      dateTime: DateTime.parse(json['date_time'] ?? DateTime.now().toIso8601String()),
      isLive: json['is_live'] ?? false,
      category: json['category'] != null
          ? ServiceCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => ServiceCategory.sundayService,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'date_time': dateTime.toIso8601String(),
      'is_live': isLive,
      'category': category?.name,
    };
  }
}