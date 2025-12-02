import '../../core/constants/app_constants.dart';
import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    super.thumbnailUrl,
    required super.dateTime,
    super.isLive = false,
    super.category,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      dateTime: DateTime.parse(json['date_time']),
      isLive: json['is_live'] ?? false,
      category: _parseServiceCategory(json['category']),
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

  static ServiceCategory? _parseServiceCategory(String? category) {
    if (category == null) return null;
    
    switch (category) {
      case 'morningDew':
        return ServiceCategory.morningDew;
      case 'feastOfGlory':
        return ServiceCategory.feastOfGlory;
      case 'wordAndPrayer':
        return ServiceCategory.wordAndPrayer;
      case 'schoolOfChrist':
        return ServiceCategory.schoolOfChrist;
      case 'kingdomBusiness':
        return ServiceCategory.kingdomBusiness;
      case 'sundayService':
        return ServiceCategory.sundayService;
      default:
        return null;
    }
  }
}