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
    super.isLive,
    super.pastor,
    super.scripture,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
      type: ContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContentType.video,
      ),
      category: json['category'] != null
          ? ServiceCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => ServiceCategory.sundayService,
            )
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'])
          : null,
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
      'duration': duration?.inSeconds,
      'is_live': isLive,
      'pastor': pastor,
      'scripture': scripture,
    };
  }
}