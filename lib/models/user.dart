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
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profile_image_url'],
      isOnline: json['is_online'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'is_online': isOnline,
    };
  }
  
  @override
  List<Object?> get props => [id, name, email, profileImageUrl, isOnline];
}