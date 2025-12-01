import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class MockDataSource {
  static Future<UserModel> mockSignIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    if (email == 'test@email.com' && password == 'password') {
      return const UserModel(
        id: '1',
        name: 'Abayomi Temiotan',
        email: 'test@email.com',
        isOnline: true,
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  static Future<List<ContentModel>> getMockRecentContent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      ContentModel(
        id: '1',
        title: 'Feast of Glory Service - "Faith Over Fear"',
        description: 'Pastor Adedayo • 2 hours ago',
        type: ContentType.video,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: ServiceCategory.feastOfGlory,
        duration: const Duration(minutes: 45),
        pastor: 'Pastor Adedayo',
      ),
      ContentModel(
        id: '2',
        title: 'Daily Devotion - November 17',
        description: 'Psalms 23:1 • This morning',
        type: ContentType.audio,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        duration: const Duration(minutes: 15),
      ),
      ContentModel(
        id: '3',
        title: 'Word and Prayer',
        description: 'Psalms 23:1 • This morning',
        type: ContentType.video,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        category: ServiceCategory.wordAndPrayer,
        duration: const Duration(hours: 1, minutes: 30),
      ),
    ];
  }

  static Future<List<EventModel>> getMockUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      EventModel(
        id: '1',
        title: 'PRE-CONFERENCE SERVICE\nTHE SON OF GOD',
        description: 'Image & Glory Conference',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        isLive: true,
        category: ServiceCategory.feastOfGlory,
      ),
      EventModel(
        id: '2',
        title: 'Believers\' Meeting',
        description: 'Fellowship',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        isLive: false,
      ),
      EventModel(
        id: '3',
        title: 'THIS GOSPEL OF\nTHE KINGDOM',
        description: 'Kingdom Herald Summit',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        isLive: false,
      ),
    ];
  }
}