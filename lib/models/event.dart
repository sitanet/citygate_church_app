import 'package:equatable/equatable.dart';
import '../core/constants/app_constants.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final DateTime dateTime;
  final bool isLive;
  final ServiceCategory? category;
  
  const Event({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.dateTime,
    this.isLive = false,
    this.category,
  });
  
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
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
  
  @override
  List<Object?> get props => [id, title, description, thumbnailUrl, dateTime, isLive, category];
}