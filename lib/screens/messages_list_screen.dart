import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'media_screen.dart';

class MessagesListScreen extends StatefulWidget {
  final MediaCategory initialCategory;
  final List<MediaCategory> allCategories;
  final int initialTypeIndex; // 0=Audio,1=Video,2=Transcript

  const MessagesListScreen({
    Key? key,
    required this.initialCategory,
    required this.allCategories,
    this.initialTypeIndex = 0,
  }) : super(key: key);

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  late MediaCategory _currentCategory;
  late int _typeIndex;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.initialCategory;
    _typeIndex = widget.initialTypeIndex;
  }

  @override
  Widget build(BuildContext context) {
    final items = _mockMessages(_currentCategory.id).where((m) {
      if (_query.isEmpty) return true;
      return m.title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_currentCategory.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search messages',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          _CategoryChips(
            categories: widget.allCategories,
            selectedId: _currentCategory.id,
            onSelected: (c) => setState(() => _currentCategory = c),
          ),
          const SizedBox(height: 8),
          _TypeTabs(
            index: _typeIndex,
            onChanged: (i) => setState(() => _typeIndex = i),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemBuilder: (_, i) {
                final m = items[i];
                return _MessageTile(title: m.title, subtitle: m.subtitle);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }

  List<_Message> _mockMessages(String categoryId) {
    final base = [
      _Message('The Morning Dew', 'Pastor Adedayo • 2 hours ago'),
      _Message('Way of Discipleship', 'Psalms 23:1 • This morning'),
      _Message('Way of Prayer', 'Psalms 23:1 • This morning'),
      _Message('Daily Devotion - November 17', 'Psalms 23:1 • This morning'),
      _Message('Daily Devotion - November 18', 'Psalms 23:1 • This morning'),
      _Message('Faith Over Fear', 'Feast of Glory • Yesterday'),
    ];
    return List.generate(base.length, (i) => base[i]);
  }
}

class _TypeTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _TypeTabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = const ['Audio', 'Video', 'Transcript'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: selected ? AppColors.onSurface : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
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

class _CategoryChips extends StatelessWidget {
  final List<MediaCategory> categories;
  final String selectedId;
  final ValueChanged<MediaCategory> onSelected;
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final c = categories[i];
          final selected = c.id == selectedId;
          return ChoiceChip(
            label: Text(
              c.title,
              style: TextStyle(
                color: selected ? AppColors.onSurface : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: selected,
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary.withOpacity(0.15),
            side: BorderSide(color: Colors.black12.withOpacity(0.06)),
            onSelected: (_) => onSelected(c),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const _MessageTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppStyles.cardShadow],
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to detail / playback
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Open message')),
          );
        },
      ),
    );
  }
}

class _Message {
  final String title;
  final String subtitle;
  const _Message(this.title, this.subtitle);
}