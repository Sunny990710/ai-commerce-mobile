import 'package:flutter/material.dart';

import 'onboarding/onboarding_data.dart';
import 'onboarding/onboarding_flow.dart';

/// 나와 같은 체형/피부톤을 가진 사람들의 옷차림을 보여주는 무드보드
class ExploreScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ExploreScreen({super.key, this.onBack});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

enum _ExploreTab { item, coordination }

class _ExploreScreenState extends State<ExploreScreen> {
  OnboardingData? _data;
  bool _loading = true;
  _ExploreTab _selectedTab = _ExploreTab.item;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadOnboardingData();
    if (mounted) setState(() {
      _data = data;
      _loading = false;
    });
  }

  /// 무드보드용 패션/아웃핏 이미지 - 다양한 비율로 무드보드 느낌
  static const _coordinationImages = [
    'assets/images/outfit_flatlay2.png',
    'assets/images/outfit_flatlay3.png',
    'assets/images/outfit_flatlay.png',
  ];

  static const _moodboardImages = [
    ('https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600', 0.7),
    ('https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=600', 1.4),
    ('https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=600', 1.35),
    ('https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600', 0.75),
    ('https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=600', 1.2),
    ('https://images.unsplash.com/photo-1445205170230-053b83016050?w=600', 0.85),
    ('https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600', 1.5),
    ('https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=600', 0.8),
    ('https://images.unsplash.com/photo-1475180098004-ca77a66827be?w=600', 1.25),
    ('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600', 0.9),
    ('https://images.unsplash.com/photo-1558171813-4c088753af8f?w=600', 1.15),
    ('https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=600', 0.95),
  ];

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('탐색', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
          centerTitle: true,
          elevation: 0,
          leading: widget.onBack != null ? IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20), onPressed: widget.onBack) : null,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bodyType = _data?.bodyType ?? '체형';
    final colorTone = _data?.colorTone ?? '피부톤';
    final bodyLabel = bodyType == '잘 모르겠어요' ? '' : bodyType;
    final toneLabel = colorTone == '잘 모르겠어요' ? '' : colorTone;
    final subtitle = [
      if (bodyLabel.isNotEmpty) bodyLabel,
      if (toneLabel.isNotEmpty) toneLabel,
    ].join(' · ');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('탐색', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        elevation: 0,
        leading: widget.onBack != null ? IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20), onPressed: widget.onBack) : null,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나와 비슷한 체형·피부톤 스타일',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '나와 비슷한 스타일의 사람들은 어떤 옷을 입을까요?',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 1))],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabChip(
                            label: '아이템',
                            selected: _selectedTab == _ExploreTab.item,
                            onTap: () => setState(() => _selectedTab = _ExploreTab.item),
                          ),
                        ),
                        Expanded(
                          child: _TabChip(
                            label: '코디',
                            selected: _selectedTab == _ExploreTab.coordination,
                            onTap: () => setState(() => _selectedTab = _ExploreTab.coordination),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: _selectedTab == _ExploreTab.coordination
                  ? _CoordinationGrid(images: _coordinationImages)
                  : _MoodboardGrid(images: _moodboardImages),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 1))] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.grey[800] : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoordinationGrid extends StatelessWidget {
  final List<String> images;

  const _CoordinationGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;
    final screenWidth = MediaQuery.of(context).size.width - 24;
    final cellSize = (screenWidth - spacing) / 2;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: images.map((path) {
        return SizedBox(
          width: cellSize,
          height: cellSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(path, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}

class _MoodboardGrid extends StatelessWidget {
  final List<(String, double)> images;

  const _MoodboardGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 24;
    const spacing = 8.0;
    final cellWidth = (screenWidth - spacing) / 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < images.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MoodboardTile(
                  url: images[i].$1,
                  aspect: images[i].$2,
                  cellWidth: cellWidth,
                ),
              ),
              if (i + 1 < images.length) ...[
                const SizedBox(width: spacing),
                Expanded(
                  child: _MoodboardTile(
                    url: images[i + 1].$1,
                    aspect: images[i + 1].$2,
                    cellWidth: cellWidth,
                  ),
                ),
              ],
            ],
          ),
          if (i + 1 < images.length) const SizedBox(height: spacing),
        ],
      ],
    );
  }
}

class _MoodboardTile extends StatelessWidget {
  final String url;
  final double aspect;
  final double cellWidth;

  const _MoodboardTile({
    required this.url,
    required this.aspect,
    required this.cellWidth,
  });

  @override
  Widget build(BuildContext context) {
    final height = cellWidth / aspect;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: cellWidth,
        height: height,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, size: 32, color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }
}
