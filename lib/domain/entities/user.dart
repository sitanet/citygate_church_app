import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final bool isOnline;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.isOnline = false,
  });
  
  @override
  List<Object?> get props => [id, name, email, profileImageUrl, isOnline];
}