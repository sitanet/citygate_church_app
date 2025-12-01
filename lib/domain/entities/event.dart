import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

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
  
  @override
  List<Object?> get props => [id, title, description, thumbnailUrl, dateTime, isLive, category];
}