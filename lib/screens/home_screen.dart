import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../models/content.dart';
import '../models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _eventsController;

  @override
  void initState() {
    super.initState();
    _eventsController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Upcoming Events'),
                      const SizedBox(height: 12),
                      _buildUpcomingEvents(_getMockUpcomingEvents()),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Recent Activities'),
                      const SizedBox(height: 12),
                      _buildRecentActivities(_getMockRecentContent()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const headerHeight = 240.0; // compact to bring events closer

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/home_bg.png'),
          fit: BoxFit.cover, // fully cover the rounded area
        ),
      ),
      // LIGHTER overlay to avoid looking too dark
      foregroundDecoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.05),
            Colors.black.withOpacity(0.15),
            Colors.black.withOpacity(0.35),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.textLight),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Centered: Logo + (Welcome / Church / Motto)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  _LogoBox(),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'The CityGate Church',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Where sons are raised',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'James Afolayan',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUpcomingEvents(List<Event> events) {
    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: _eventsController,
        builder: (context, _) {
          final page = _eventsController.hasClients && _eventsController.page != null
              ? _eventsController.page!
              : _eventsController.initialPage.toDouble();
          return PageView.builder(
            controller: _eventsController,
            itemCount: events.length,
            padEnds: false,
            pageSnapping: true,
            itemBuilder: (context, index) {
              final event = events[index];
              final distance = (index - page).abs();
              final scale = (1 - (distance * 0.12)).clamp(0.9, 1.0);
              final translateY = (1 - scale) * 20.0;

              return Transform.translate(
                offset: Offset(0, translateY),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(right: index < events.length - 1 ? 12 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            event.thumbnailUrl ??
                                'assets/images/events/son_of_god.jpg.png',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.25),
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (event.isLive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.live,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.description,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentActivities(List<Content> activities) {
    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [AppStyles.cardShadow],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: activity.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          activity.thumbnailUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        activity.type == ContentType.video
                            ? Icons.play_arrow
                            : Icons.headphones,
                        color: AppColors.textSecondary,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Event> _getMockUpcomingEvents() {
    const defaultThumb = 'assets/images/events/son_of_god.jpg.png';
    return [
      Event(
        id: '1',
        title: 'PRE-CONFERENCE SERVICE\nTHE SON OF GOD',
        description: 'Image & Glory Conference',
        thumbnailUrl: defaultThumb,
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        isLive: true,
        category: ServiceCategory.feastOfGlory,
      ),
      Event(
        id: '2',
        title: 'Believers\' Meeting',
        description: 'Fellowship',
        thumbnailUrl: defaultThumb,
        dateTime: DateTime.now().add(const Duration(days: 1)),
        isLive: false,
      ),
      Event(
        id: '3',
        title: 'THIS GOSPEL OF\nTHE KINGDOM',
        description: 'Kingdom Herald Summit',
        thumbnailUrl: defaultThumb,
        dateTime: DateTime.now().add(const Duration(days: 3)),
        isLive: false,
      ),
    ];
  }

  List<Content> _getMockRecentContent() {
    return [
      Content(
        id: '1',
        title: 'Feast of Glory Service - "Faith Over Fear"',
        description: 'Pastor Adedayo • 2 hours ago',
        type: ContentType.video,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: ServiceCategory.feastOfGlory,
      ),
      Content(
        id: '2',
        title: 'Daily Devotion - November 17',
        description: 'Psalms 23:1 • This morning',
        type: ContentType.audio,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
}

class _LogoBox extends StatelessWidget {
  const _LogoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
    }
}