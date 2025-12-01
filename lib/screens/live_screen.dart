import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _tabIndex = 1; // 0 = Watch Live, 1 = Stream Live (default to Stream Live view)

  // Simple player state (UI only)
  bool _playing = true;
  Duration _position = const Duration(seconds: 12);
  Duration _duration = const Duration(minutes: 3, seconds: 46);
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _maybeStartTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _maybeStartTicker() {
    _ticker?.cancel();
    if (_playing) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          final next = _position + const Duration(seconds: 1);
          _position = next >= _duration ? _duration : next;
          if (_position >= _duration) {
            _playing = false;
            _ticker?.cancel();
          }
        });
      });
    }
  }

  String _formatRemaining() {
    final remaining = _duration - _position;
    final mm = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '-$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          _buildSegmented(),
          const SizedBox(height: 20),
          if (_tabIndex == 0) ...[
            // Watch Live (same hero card + list as before; keep simple)
            const _SectionTitle('Watch Live Service'),
            const SizedBox(height: 12),
            const _LiveHeroCard(
              image: 'assets/images/events/son_of_god.jpg.png',
              title: 'PRE-CONFERENCE SERVICE\nTHE SON OF GOD',
            ),
            const SizedBox(height: 16),
            _ServiceRow.live(
              icon: Icons.church,
              title: 'Sunday Service',
              subtitle: 'Every Sunday 8:00am',
            ),
            const SizedBox(height: 10),
            _ServiceRow.soon(
              icon: Icons.menu_book_rounded,
              title: 'Word & Prayer',
              subtitle: 'Every Tuesday 5:00pm',
            ),
            const SizedBox(height: 10),
            _ServiceRow.soon(
              icon: Icons.school_rounded,
              title: 'The School of Christ',
              subtitle: 'Every Thursday 5:00pm',
            ),
          ] else ...[
            // Stream Live
            const _SectionTitle('Now Playing'),
            const SizedBox(height: 12),
            _ArtworkCard(image: 'assets/images/events/son_of_god.jpg.png'),
            const SizedBox(height: 12),
            // Progress + LIVE badge + remaining
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: _position.inMilliseconds.toDouble(),
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    activeColor: AppColors.secondary,
                    onChanged: (v) {
                      setState(() {
                        _position = Duration(milliseconds: v.toInt());
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.live,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatRemaining(),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleIconButton(
                  icon: Icons.skip_previous_rounded,
                  onTap: () {
                    setState(() {
                      final back = _position - const Duration(seconds: 15);
                      _position = back <= Duration.zero ? Duration.zero : back;
                    });
                  },
                ),
                const SizedBox(width: 24),
                _CircleIconButton(
                  filled: true,
                  icon: _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  onTap: () {
                    setState(() {
                      _playing = !_playing;
                      _maybeStartTicker();
                    });
                  },
                ),
                const SizedBox(width: 24),
                _CircleIconButton(
                  icon: Icons.skip_next_rounded,
                  onTap: () {
                    setState(() {
                      final fwd = _position + const Duration(seconds: 15);
                      _position = fwd >= _duration ? _duration : fwd;
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmented() {
    final tabs = const ['Watch Live', 'Stream Live'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
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

// UI bits

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _LiveHeroCard extends StatelessWidget {
  final String image;
  final String title;

  const _LiveHeroCard({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.45),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.play_arrow_rounded, size: 36, color: Colors.black),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArtworkCard extends StatelessWidget {
  final String image;
  const _ArtworkCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [AppStyles.cardShadow],
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _ServiceRow._({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  factory _ServiceRow.live({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return _ServiceRow._(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.live,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'LIVE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  factory _ServiceRow.soon({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return _ServiceRow._(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.schedule_rounded, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.onSurface),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: trailing,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open $title')),
          );
        },
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.primary : Colors.white,
          boxShadow: [AppStyles.cardShadow],
        ),
        child: Icon(
          icon,
          color: filled ? AppColors.onSurface : AppColors.onSurface,
          size: 28,
        ),
      ),
    );
  }
}