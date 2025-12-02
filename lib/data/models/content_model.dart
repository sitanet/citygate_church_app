import '../../core/constants/app_constants.dart';
import '../../domain/entities/content.dart';

class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.title,
    required super.description,
    super.thumbnailUrl,
    super.videoUrl,
    super.audioUrl,
    required super.type,
    super.category,
    required super.createdAt,
    super.duration,
    super.isLive = false,
    super.pastor,
    super.scripture,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
      type: _parseContentType(json['type']),
      category: _parseServiceCategory(json['category']),
      createdAt: DateTime.parse(json['created_at']),
      duration: _parseDuration(json['duration']),
      isLive: json['is_live'] ?? false,
      pastor: json['pastor'],
      scripture: json['scripture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'type': type.name,
      'category': category?.name,
      'created_at': createdAt.toIso8601String(),
      'duration': formattedDuration,
      'is_live': isLive,
      'pastor': pastor,
      'scripture': scripture,
    };
  }

  static ContentType _parseContentType(String? type) {
    switch (type?.toLowerCase()) {
      case 'video':
        return ContentType.video;
      case 'audio':
        return ContentType.audio;
      case 'live':
        return ContentType.live;
      default:
        return ContentType.video;
    }
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

  static Duration? _parseDuration(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) return null;
    
    try {
      final parts = durationStr.split(':');
      if (parts.length == 2) {
        // MM:SS format
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      } else if (parts.length == 3) {
        // HH:MM:SS format
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }
}