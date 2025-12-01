import 'package:equatable/equatable.dart';
import '../core/constants/app_constants.dart';

class Content extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String? audioUrl;
  final ContentType type;
  final ServiceCategory? category;
  final DateTime createdAt;
  final Duration? duration;
  final bool isLive;
  final String? pastor;
  final String? scripture;
  
  const Content({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.videoUrl,
    this.audioUrl,
    required this.type,
    this.category,
    required this.createdAt,
    this.duration,
    this.isLive = false,
    this.pastor,
    this.scripture,
  });
  
  String get formattedDuration {
    if (duration == null) return '';
    
    final hours = duration!.inHours;
    final minutes = duration!.inMinutes % 60;
    final seconds = duration!.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
  
  @override
  List<Object?> get props => [
    id, title, description, thumbnailUrl, videoUrl, audioUrl,
    type, category, createdAt, duration, isLive, pastor, scripture
  ];
}