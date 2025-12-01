import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'messages_list_screen.dart';

class MediaCategory {
  final String id;
  final String title;
  final List<Color> gradient;
  final String? image;

  const MediaCategory({
    required this.id,
    required this.title,
    required this.gradient,
    this.image,
  });
}

class VideoItem {
  final String title;
  final String image;
  final Duration duration;
  const VideoItem({
    required this.title,
    required this.image,
    required this.duration,
  });
}

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  int _typeIndex = 0; // 0=Audio, 1=Video, 2=Transcript

  final List<MediaCategory> _categories = const [
    MediaCategory(
      id: 'morning_dew',
      title: 'The Morning Dew',
      gradient: [Color(0xFFCBB57A), Color(0xFF8F7A38)],
      image: 'assets/images/events/son_of_god.jpg.png',
    ),
    MediaCategory(
      id: 'feast_of_glory',
      title: 'Feast of Glory Service',
      gradient: [Color(0xFFFF5A4E), Color(0xFFE74625)],
      image: 'assets/images/events/son_of_god.jpg.png',
    ),
    MediaCategory(
      id: 'word_and_prayer',
      title: 'Word and Prayer',
      gradient: [Color(0xFF8A2A2A), Color(0xFF5E1B1B)],
      image: 'assets/images/events/son_of_god.jpg.png',
    ),
    MediaCategory(
      id: 'school_of_christ',
      title: 'The School of Christ',
      gradient: [Color(0xFF222222), Color(0xFF000000)],
      image: 'assets/images/events/son_of_god.jpg.png',
    ),
    MediaCategory(
      id: 'kingdom_business',
      title: 'Kingdom Business',
      gradient: [Color(0xFF8A2BE2), Color(0xFF5C1FAE)],
      image: 'assets/images/events/son_of_god.jpg.png',
    ),
  ];

  final List<VideoItem> _videos = const [
    VideoItem(
      title: 'PRE-CONFERENCE SERVICE — THE SON OF GOD',
      image: 'assets/images/events/son_of_god.jpg.png',
      duration: Duration(minutes: 3, seconds: 46),
    ),
    VideoItem(
      title: 'THIS GOSPEL OF THE KINGDOM',
      image: 'assets/images/events/son_of_god.jpg.png',
      duration: Duration(minutes: 4, seconds: 12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Media'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        children: [
          _buildTypeSwitcher(),
          const SizedBox(height: 16),
          if (_typeIndex == 0) ...[
            ..._categories.map(
              (c) => _CategoryCard(
                category: c,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MessagesListScreen(
                        initialCategory: c,
                        allCategories: _categories,
                        initialTypeIndex: _typeIndex,
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (_typeIndex == 1) ...[
            ..._videos.map((v) => _VideoCard(item: v)),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [AppStyles.cardShadow],
              ),
              child: const Text(
                'Transcripts will appear here.',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeSwitcher() {
    final tabs = const ['Audio', 'Video', 'Transcript'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (i) {
          final selected = _typeIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _typeIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: selected
                      ? const Border.fromBorderSide(
                          BorderSide(color: AppColors.secondary, width: 1.2),
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: selected ? AppColors.secondary : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// AUDIO category card
class _CategoryCard extends StatelessWidget {
  final MediaCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          height: 86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: category.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              if (category.image != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35),
                        BlendMode.darken,
                      ),
                      child: Image.asset(
                        category.image!,
                        height: double.infinity,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// VIDEO card UI (centered, black controls)
class _VideoCard extends StatelessWidget {
  final VideoItem item;
  const _VideoCard({required this.item});

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppStyles.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Artwork
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(item.image, fit: BoxFit.cover),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Play "${item.title}"')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Controls centered, black icons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous_rounded, color: Colors.black),
                  ),
                  const SizedBox(width: 18),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black, // black play button
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 18),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next_rounded, color: Colors.black),
                  ),
                ],
              ),
            ),
            // Duration aligned right
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    _fmt(item.duration),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}