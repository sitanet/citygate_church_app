import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../domain/entities/content.dart';
import '../data/datasources/remote_data_source.dart';
import '../data/repositories/content_repository_impl.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ContentRepositoryImpl _contentRepository;
  
  Map<ContentType, List<Content>> _contentByType = {};
  Map<ContentType, bool> _loadingStates = {};
  Map<ContentType, String?> _errorMessages = {};
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _contentRepository = ContentRepositoryImpl(
      remoteDataSource: RemoteDataSource(),
    );
    
    // Initialize states
    for (final type in ContentType.values) {
      _contentByType[type] = [];
      _loadingStates[type] = false;
      _errorMessages[type] = null;
    }
    
    // Load initial content for first tab (Videos)
    _loadContent(ContentType.video);
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final contentType = ContentType.values[_tabController.index];
        if (_contentByType[contentType]!.isEmpty && !_loadingStates[contentType]!) {
          _loadContent(contentType);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContent(ContentType type) async {
    try {
      setState(() {
        _loadingStates[type] = true;
        _errorMessages[type] = null;
      });

      final content = await _contentRepository.getContent(
        type: type.name,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (mounted) {
        setState(() {
          _contentByType[type] = content;
          _loadingStates[type] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessages[type] = e.toString().replaceFirst('Exception: ', '');
          _loadingStates[type] = false;
        });
      }
    }
  }

  Future<void> _refresh(ContentType type) async {
    await _loadContent(type);
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
    
    final currentType = ContentType.values[_tabController.index];
    _loadContent(currentType);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    
    final currentType = ContentType.values[_tabController.index];
    _loadContent(currentType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Media'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search content...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Videos'),
                  Tab(text: 'Audio'),
                  Tab(text: 'Live'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContentTab(ContentType.video),
          _buildContentTab(ContentType.audio),
          _buildContentTab(ContentType.live),
        ],
      ),
    );
  }

  Widget _buildContentTab(ContentType type) {
    final isLoading = _loadingStates[type] ?? false;
    final errorMessage = _errorMessages[type];
    final content = _contentByType[type] ?? [];

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading content...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return _buildErrorView(errorMessage, () => _loadContent(type));
    }

    if (content.isEmpty) {
      return _buildEmptyView(type);
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(type),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: content.length,
        itemBuilder: (context, index) {
          return _buildContentCard(content[index]);
        },
      ),
    );
  }

  Widget _buildErrorView(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              'Failed to load content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(ContentType type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == ContentType.video
                  ? Icons.video_library_outlined
                  : type == ContentType.audio
                      ? Icons.audiotrack_outlined
                      : Icons.live_tv_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No ${type.name} content available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No results found for "$_searchQuery"'
                  : 'Check back later for new ${type.name} content',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: _clearSearch,
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Content content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _playContent(content);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail/Icon
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: content.category?.color.withOpacity(0.1) ?? AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    if (content.thumbnailUrl != null && content.thumbnailUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          content.thumbnailUrl!,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(content),
                        ),
                      )
                    else
                      _buildDefaultIcon(content),
                    if (content.isLive)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Content Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (content.pastor != null)
                      Text(
                        content.pastor!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (content.category != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: content.category!.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          content.category!.displayName,
                          style: TextStyle(
                            color: content.category!.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          content.timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (content.duration != null) ...[
                          const Text(' • '),
                          Text(
                            content.formattedDuration,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Action Button
              IconButton(
                onPressed: () {
                  _showContentOptionsBottomSheet(content);
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(Content content) {
    return Center(
      child: Icon(
        content.type == ContentType.video
            ? Icons.play_circle_filled
            : content.type == ContentType.audio
                ? Icons.audiotrack
                : Icons.live_tv,
        size: 32,
        color: content.category?.color ?? AppColors.primary,
      ),
    );
  }

  void _showContentOptionsBottomSheet(Content content) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: Text(content.isLive ? 'Watch Live' : 'Play'),
                onTap: () {
                  Navigator.pop(context);
                  _playContent(content);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  _shareContent(content);
                },
              ),
              if (!content.isLive)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download'),
                  onTap: () {
                    Navigator.pop(context);
                    _downloadContent(content);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showContentDetails(content);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _playContent(Content content) {
    // TODO: Navigate to video/audio player
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${content.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent(Content content) {
    // TODO: Implement content sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${content.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _downloadContent(Content content) {
    // TODO: Implement content download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading: ${content.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showContentDetails(Content content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(content.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content.pastor != null) ...[
                  Text('Pastor: ${content.pastor}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                ],
                if (content.scripture != null) ...[
                  Text('Scripture: ${content.scripture}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                ],
                if (content.category != null) ...[
                  Text('Category: ${content.category!.displayName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                ],
                Text(content.description),
                const SizedBox(height: 8),
                Text('Published: ${content.timeAgo}'),
                if (content.duration != null) ...[
                  const SizedBox(height: 4),
                  Text('Duration: ${content.formattedDuration}'),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _playContent(content);
              },
              child: Text(content.isLive ? 'Watch Live' : 'Play'),
            ),
          ],
        );
      },
    );
  }
}