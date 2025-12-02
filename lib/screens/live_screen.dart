import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../domain/entities/content.dart';
import '../data/datasources/remote_data_source.dart';
import '../data/repositories/content_repository_impl.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _tabIndex = 0; // 0 = Watch Live, 1 = Stream Live
  late ContentRepositoryImpl _contentRepository;
  
  List<Content> _liveContent = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Simple player state (for UI demonstration)
  bool _playing = false;
  Duration _position = const Duration(seconds: 0);
  Duration _duration = const Duration(minutes: 0);
  Timer? _ticker;
  Content? _currentContent;

  @override
  void initState() {
    super.initState();
    _contentRepository = ContentRepositoryImpl(
      remoteDataSource: RemoteDataSource(),
    );
    _loadLiveContent();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _loadLiveContent() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final content = await _contentRepository.getLiveContent();

      if (mounted) {
        setState(() {
          _liveContent = content;
          _isLoading = false;
          
          // Auto-select first live content if available
          if (_liveContent.isNotEmpty && _currentContent == null) {
            _currentContent = _liveContent.first;
            _duration = _currentContent!.duration ?? const Duration(minutes: 60); // Default 1 hour for live
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
          _liveContent = [];
        });
      }
    }
  }

  Future<void> _refresh() async {
    await _loadLiveContent();
  }

  void _maybeStartTicker() {
    _ticker?.cancel();
    if (_playing && _currentContent != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          final next = _position + const Duration(seconds: 1);
          _position = next >= _duration ? _duration : next;
          if (_position >= _duration && !_currentContent!.isLive) {
            _playing = false;
            _ticker?.cancel();
          }
        });
      });
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatRemaining() {
    final remaining = _duration - _position;
    return _currentContent?.isLive == true ? 'LIVE' : '-${_formatTime(remaining)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selection
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildTabButton('Watch Live', 0),
                _buildTabButton('Stream Live', 1),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _tabIndex == 0 ? _buildWatchLiveTab() : _buildStreamLiveTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatchLiveTab() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading live content...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_liveContent.isEmpty) {
      return _buildNoLiveStreamView();
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Main Live Player
            if (_currentContent != null) _buildMainPlayer(),
            
            // Live Content List
            if (_liveContent.length > 1) _buildLiveContentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPlayer() {
    return Container(
      height: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Video placeholder/thumbnail
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: _currentContent!.thumbnailUrl != null && _currentContent!.thumbnailUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _currentContent!.thumbnailUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.live_tv,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.live_tv,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
          ),
          
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Live indicator
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.live,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _currentContent!.isLive ? 'LIVE' : 'RECORDED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Play button overlay
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _playing = !_playing;
                  _maybeStartTicker();
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          
          // Controls at bottom
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _playing = !_playing;
                      _maybeStartTicker();
                    });
                  },
                  icon: Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: _currentContent!.isLive
                      ? Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.live,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      : Slider(
                          value: _position.inSeconds.toDouble(),
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              _position = Duration(seconds: value.toInt());
                            });
                          },
                          activeColor: AppColors.primary,
                          inactiveColor: Colors.white.withOpacity(0.3),
                        ),
                ),
                Text(
                  _formatRemaining(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveContentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Live Streams',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _liveContent.length - 1,
            itemBuilder: (context, index) {
              final content = _liveContent[index + 1]; // Skip first item (already shown)
              return _buildLiveContentCard(content);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLiveContentCard(Content content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surfaceVariant,
          ),
          child: content.thumbnailUrl != null && content.thumbnailUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    content.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.live_tv,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : const Icon(
                  Icons.live_tv,
                  color: AppColors.textSecondary,
                ),
        ),
        title: Text(
          content.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            if (content.isLive) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.live,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (content.pastor != null)
              Expanded(
                child: Text(
                  content.pastor!,
                  style: const TextStyle(color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        onTap: () {
          setState(() {
            _currentContent = content;
            _position = Duration.zero;
            _duration = content.duration ?? const Duration(minutes: 60);
            _playing = false;
          });
        },
      ),
    );
  }

  Widget _buildStreamLiveTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_outlined, size: 80, color: AppColors.textSecondary),
            SizedBox(height: 24),
            Text(
              'Start Live Stream',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Live streaming feature is coming soon!\nYou\'ll be able to broadcast directly from your device.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text(
                      'Requirements for live streaming:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Stable internet connection'),
                    Text('• Camera and microphone permissions'),
                    Text('• Admin approval for streaming'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLiveStreamView() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.live_tv_outlined,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 24),
                Text(
                  'No Live Streams',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No live streams are currently active.\nCheck back later for live church services!',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppColors.error,
                ),
                const SizedBox(height: 24),
                Text(
                  'Failed to load live content',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _errorMessage ?? 'Unknown error occurred',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}