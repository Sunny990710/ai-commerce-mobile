import 'package:flutter/material.dart';

import '../constants/mock_data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'closet_item_detail_screen.dart';
import 'clothing_search_screen.dart';
import 'product_detail_screen.dart';

class ClosetScreen extends StatefulWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final void Function(String? prompt)? onGoToChat;
  final VoidCallback? onGoToMy;
  final VoidCallback? onBack;

  const ClosetScreen({super.key, required this.wishIds, required this.onToggleWish, this.onGoToChat, this.onGoToMy, this.onBack});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  static const _targetCount = 7;

  // 카테고리별 등록 수 (상의, 하의, 아우터, 신발)
  List<int> _categoryCounts = [3, 2, 0, 0];

  int get _uploadedCount => _categoryCounts.fold(0, (a, b) => a + b);
  static const _categoryTotals = [4, 3, 1, 1];
  static const _categoryLabels = ['상의', '하의', '아우터', '신발'];
  int _selectedCategoryIndex = 0;
  int _selectedOutfitCategoryIndex = 0;
  String _filterMode = 'all'; // 'all' | 'brand' | 'coordi'
  int _selectedBrandIndex = -1; // -1: 전체, 0~7: 각 브랜드

  static const _filterOptions = ['모든 옷', '브랜드', '코디'];
  static const _brands = ['스파오', '미쏘', '자라', '뉴발란스', '헤지스', '키디키디', '시슬리', '타임'];
  static const _brandLogos = {
    '스파오': 'assets/images/spao_logo.png',
    '미쏘': 'assets/images/mixxo_logo.png',
    '자라': 'assets/images/zara_logo.png',
    '뉴발란스': 'assets/images/newbalance_logo.png',
    '헤지스': 'assets/images/hazzys_logo.png',
    '키디키디': 'assets/images/kiddikiddi_logo.png',
    '시슬리': 'assets/images/sisley_logo.png',
    '타임': 'assets/images/time_logo.png',
  };
  static const _categories = ['전체', '상의', '원피스', '바지', '치마', '아우터', '신발', '가방'];

  static const _outfitCategories = [
    ('데일리', Icons.coffee, Color(0xFFF5E6D3), Color(0xFF8B7355), 3),
    ('출근룩', Icons.work_outline, Color(0xFFD4E8F7), Color(0xFF2E5A8E), 2),
    ('데이트', Icons.local_florist, Color(0xFFF8D7E3), Color(0xFF8B3A4A), 1),
    ('여행', Icons.flight_takeoff, Color(0xFFD8EDD8), Color(0xFF3A6B3A), 2),
    ('운동', Icons.directions_run, Color(0xFFE8D4F0), Color(0xFF6B3A7B), 1),
  ];

  static const _itemGridImages = [
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
    'https://images.unsplash.com/photo-1576566588028-4147f3845f81?w=400',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400',
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('옷장', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        leading: widget.onBack != null ? IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20), onPressed: widget.onBack) : null,
        actions: [
          if (widget.onGoToMy != null)
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: widget.onGoToMy,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadCard(),
            const SizedBox(height: 16),
            _buildWeatherRecommend(),
            const SizedBox(height: 24),
            _buildTodayCodiHeader(),
            const SizedBox(height: 12),
            _buildOutfitCategories(),
            const SizedBox(height: 16),
            _buildOutfitCards(),
            const SizedBox(height: 28),
            _buildFilterSortRow(),
            const SizedBox(height: 16),
            if (_filterMode == 'brand') ...[
              _buildBrandCarousel(),
              const SizedBox(height: 20),
            ],
            if (_filterMode != 'coordi') ...[
              _buildCategoryTabs(),
              const SizedBox(height: 20),
            ],
            if (_filterMode == 'coordi')
              _buildCoordiView()
            else
              _buildItemGrid(),
            if (widget.wishIds.isNotEmpty) ...[
              const SizedBox(height: 28),
              _buildWishlistSection(),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showAddItemModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddItemModal(
        onDismiss: () => Navigator.pop(ctx),
        onUploadFromGallery: () => Navigator.pop(ctx),
        onTakePhoto: () => Navigator.pop(ctx),
        onSearchGoogle: () {
          Navigator.pop(ctx);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const ClothingSearchScreen(initialQuery: 'SPAO 여성 라운드넥 가디건'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadCard() {
    final progress = _uploadedCount / _targetCount;
    final remaining = (_targetCount - _uploadedCount).clamp(0, _targetCount);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.checkroom, size: 22, color: Color(0xFF1976D2)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_uploadedCount/$_targetCount 아이템 등록 완료',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    remaining > 0 ? '$remaining개만 더 등록하면 AI 코디가 활성화돼요' : 'AI 코디가 활성화되었어요',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF424242)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(4, (i) {
              final hasTotal = i < 2;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_categoryCounts[i]}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasTotal ? '${_categoryLabels[i]} / ${_categoryTotals[i]}' : _categoryLabels[i],
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _showAddItemModal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('아이템 추가', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherRecommend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny, size: 28, color: Colors.orange[400]),
          const SizedBox(width: 12),
          Text('22°', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(width: 8),
          Text('서울 · 맑음', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onGoToChat?.call('가벼운 아우터 추천'),
              behavior: HitTestBehavior.opaque,
              child: Text(
                '가벼운 아우터 추천',
                style: TextStyle(fontSize: 13, color: Colors.blue[700], fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCodiHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '오늘의 코디',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        TextButton(
          onPressed: _showMoodEditModal,
          child: Text('무드 편집', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ),
      ],
    );
  }

  void _showMoodEditModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _MoodEditModal(
        onDismiss: () => Navigator.pop(ctx),
        onSave: () {
          Navigator.pop(ctx);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('무드 설정이 저장되었어요')));
          }
        },
      ),
    );
  }

  Widget _buildOutfitCategories() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(_outfitCategories.length, (i) {
          final c = _outfitCategories[i];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _selectedOutfitCategoryIndex = i),
              child: _OutfitCategoryChip(
                label: c.$1,
                icon: c.$2,
                bgColor: c.$3,
                textColor: c.$4,
                count: c.$5,
                isSelected: _selectedOutfitCategoryIndex == i,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOutfitCards() {
    final count = _outfitCategories[_selectedOutfitCategoryIndex].$5;
    final occasionLabel = _outfitCategories[_selectedOutfitCategoryIndex].$1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 340,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _OutfitCard(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('코디 추가', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                  ],
                ),
              ),
              ...List.generate(count.clamp(1, 5), (i) => _CoordinateOutfitCard(index: i, occasionLabel: occasionLabel)),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterModeMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filterOptions.map((opt) {
              final isSelected = (opt == '모든 옷' && _filterMode == 'all') ||
                  (opt == '브랜드' && _filterMode == 'brand') ||
                  (opt == '코디' && _filterMode == 'coordi');
              return ListTile(
                title: Text(opt, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  setState(() {
                    _filterMode = opt == '모든 옷' ? 'all' : (opt == '브랜드' ? 'brand' : 'coordi');
                    if (_filterMode == 'brand') _selectedBrandIndex = -1;
                  });
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSortRow() {
    final modeLabel = _filterMode == 'all' ? '모든 옷' : (_filterMode == 'brand' ? '브랜드' : '코디');
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showFilterModeMenu,
            child: Row(
              children: [
                Text(modeLabel, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.tune, size: 22, color: Colors.grey[700]),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text('등록일순', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBrandCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '브랜드',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedBrandIndex = -1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _selectedBrandIndex == -1 ? Colors.black87 : Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                        ),
                        child: Center(
                          child: Text(
                            '전',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _selectedBrandIndex == -1 ? Colors.white : Colors.grey[700]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 64,
                        child: Text(
                          '전체',
                          style: TextStyle(fontSize: 12, fontWeight: _selectedBrandIndex == -1 ? FontWeight.w600 : FontWeight.normal, color: Colors.grey[800]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...List.generate(_brands.length, (i) {
                final selected = _selectedBrandIndex == i;
                final logoPath = _brandLogos[_brands[i]];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBrandIndex = i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: selected ? Border.all(color: Colors.black87, width: 2) : Border.all(color: Colors.grey[300]!),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                          ),
                          child: ClipOval(
                            child: logoPath != null
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(logoPath, fit: BoxFit.contain),
                                  )
                                : Center(
                                    child: Text(
                                      _brands[i].substring(0, 1),
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 64,
                          child: Text(
                            _brands[i],
                            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Icon(Icons.arrow_forward, size: 24, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text('더보기', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoordiView() {
    const coordiImages = [
      'assets/images/outfit_flatlay2.png',
      'assets/images/outfit_flatlay3.png',
    ];
    const coordiHashtags = [
      '#AGNESB #CANADA GOOSE #나이키 #셀린느',
      '#CANADA GOOSE #AGNESB #자라 #뉴발란스',
    ];
    final screenWidth = MediaQuery.of(context).size.width - 32;
    const spacing = 12.0;
    final cardWidth = (screenWidth - spacing) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '등록한 코디',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            ...List.generate(coordiImages.length, (i) {
              return SizedBox(
                width: cardWidth,
                height: 220,
                child: _CoordiGridCard(
                  imagePath: coordiImages[i],
                  hashtags: coordiHashtags[i],
                  onTap: () {},
                  onHide: () {},
                ),
              );
            }),
            SizedBox(
              width: cardWidth,
              height: 200,
              child: _CoordiAddCard(onTap: () {}),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(_categories.length, (i) {
          final selected = i == _selectedCategoryIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? Colors.black87 : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _categories[i],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildItemGrid() {
    final allItems = [
      _GridItemData(brand: 'No Brand', category: '상의', date: '2026. 3. 16.'),
      _GridItemData(brand: 'AGNESB', category: '상의', date: '2026. 3. 16.'),
      _GridItemData(brand: 'BALENCIAGA', category: '신발', date: '2026. 3. 16.'),
      _GridItemData(brand: 'RAINS', category: '가방', date: '2026. 3. 16.'),
      _GridItemData(brand: 'H&M', category: '아우터', date: '2026. 3. 16.'),
      _GridItemData(brand: '스파오', category: '상의', date: '2026. 3. 16.'),
      _GridItemData(brand: '스파오', category: '아우터', date: '2026. 3. 16.'),
      _GridItemData(brand: '미쏘', category: '원피스', date: '2026. 3. 16.'),
      _GridItemData(brand: '미쏘', category: '바지', date: '2026. 3. 16.'),
      _GridItemData(brand: '자라', category: '상의', date: '2026. 3. 16.'),
      _GridItemData(brand: '자라', category: '원피스', date: '2026. 3. 16.'),
      _GridItemData(brand: '뉴발란스', category: '신발', date: '2026. 3. 16.'),
      _GridItemData(brand: '헤지스', category: '아우터', date: '2026. 3. 16.'),
      _GridItemData(brand: '키디키디', category: '상의', date: '2026. 3. 16.'),
      _GridItemData(brand: '시슬리', category: '원피스', date: '2026. 3. 16.'),
      _GridItemData(brand: '타임', category: '바지', date: '2026. 3. 16.'),
    ];
    var items = allItems;
    if (_filterMode == 'brand') {
      if (_selectedBrandIndex >= 0 && _selectedBrandIndex < _brands.length) {
        final brandName = _brands[_selectedBrandIndex];
        items = allItems.where((i) => i.brand == brandName).toList();
      }
      final cat = _categories[_selectedCategoryIndex];
      if (cat != '전체') {
        items = items.where((i) => i.category == cat).toList();
      }
    } else if (_filterMode == 'all') {
      final cat = _categories[_selectedCategoryIndex];
      if (cat != '전체') {
        items = items.where((i) => i.category == cat).toList();
      }
    }
    items = items.isEmpty ? allItems : items;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _GridAddCard(onTap: _showAddItemModal);
        }
        final item = items[index - 1];
        final imageUrl = _itemGridImages[(index - 1) % _itemGridImages.length];
        return _ItemGridCard(
          brand: item.brand,
          date: item.date,
          imageUrl: imageUrl,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ClosetItemDetailScreen(
                  brand: item.brand,
                  date: item.date,
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWishlistSection() {
    final wishProducts = mockProducts.where((p) => widget.wishIds.contains(p.id)).toList();
    if (wishProducts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '위시리스트',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.58,
          ),
          itemCount: wishProducts.length,
          itemBuilder: (_, i) {
            final p = wishProducts[i];
            return ProductCard(
              product: p,
              isWished: true,
              colorOptions: productColorOptions[p.id],
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        product: p,
                        wishIds: widget.wishIds,
                        onToggleWish: widget.onToggleWish,
                      ),
                    ),
                  ),
              onWish: () => widget.onToggleWish(p),
            );
          },
        ),
      ],
    );
  }
}

class _GridItemData {
  final String brand;
  final String category;
  final String date;
  _GridItemData({required this.brand, required this.category, required this.date});
}

class _CoordiGridCard extends StatelessWidget {
  final String imagePath;
  final String hashtags;
  final VoidCallback onTap;
  final VoidCallback onHide;

  const _CoordiGridCard({
    required this.imagePath,
    required this.hashtags,
    required this.onTap,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.checkroom, size: 48, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: onHide,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Text(
                hashtags,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordiAddCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CoordiAddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 48, color: Colors.grey[500]),
            const SizedBox(height: 12),
            Text('코디 추가하기', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _OutfitCategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final int count;
  final bool isSelected;

  const _OutfitCategoryChip({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.count,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: isSelected ? Border.all(color: textColor, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04), blurRadius: isSelected ? 8 : 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: textColor),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$count OUTFIT${count != 1 ? 'S' : ''}',
            style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

class _CoordinateOutfitCard extends StatelessWidget {
  final int index;
  final String occasionLabel;

  const _CoordinateOutfitCard({required this.index, required this.occasionLabel});

  static const _outfitImages = [
    'assets/images/outfit_flatlay2.png',
    'assets/images/outfit_flatlay3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final imagePath = _outfitImages[index % _outfitImages.length];
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TopIconButton(icon: Icons.edit, onTap: () {}),
                _TopIconButton(icon: Icons.favorite_border, onTap: () {}),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.checkroom, size: 48, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                  Text(occasionLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: Colors.grey[400]!),
                      foregroundColor: Colors.black87,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('아이템 보기', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text('입어보기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _OutfitCard({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: child,
      ),
    );
  }
}

class _GridAddCard extends StatelessWidget {
  final VoidCallback onTap;
  static const _bgColor = Color(0xFFE3F2FD);
  static const _borderColor = Color(0xFFBBDEFB);
  static const _accentColor = Color(0xFF1976D2);

  const _GridAddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: _accentColor, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text('추가', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}

class _ItemGridCard extends StatelessWidget {
  final String brand;
  final String date;
  final String imageUrl;
  final VoidCallback onTap;

  const _ItemGridCard({required this.brand, required this.date, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Icon(Icons.checkroom, size: 32, color: Colors.grey[400]),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Text(
                brand,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                date,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodEditModal extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onSave;

  const _MoodEditModal({required this.onDismiss, required this.onSave});

  @override
  State<_MoodEditModal> createState() => _MoodEditModalState();
}

class _MoodEditModalState extends State<_MoodEditModal> {
  final Set<int> _selectedMoods = {0, 1};
  final Set<int> _selectedStyles = {0, 2};

  static const _moods = [
    ('데일리', Icons.coffee, Color(0xFFF5E6D3)),
    ('출근룩', Icons.work_outline, Color(0xFFD4E8F7)),
    ('데이트', Icons.local_florist, Color(0xFFF8D7E3)),
    ('여행', Icons.flight_takeoff, Color(0xFFD8EDD8)),
    ('파티', Icons.celebration, Color(0xFFE8D4F0)),
    ('운동', Icons.directions_run, Color(0xFFF0E6D8)),
    ('촬영용', Icons.camera_alt_outlined, Color(0xFFE3F2FD)),
    ('홈웨어', Icons.home_outlined, Color(0xFFF5F5F5)),
    ('직접 추가', Icons.add, Color(0xFFFFFFFF)),
  ];

  static const _styleKeywords = ['미니멀', '캐주얼', '모던', '빈티지', '스트릿', '아메카지', '시크', '러블리', '클래식', '스포티', '에슬레저'];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '무드 & 스타일 설정',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onDismiss,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '나의 라이프스타일에 맞는 무드를 선택하면 더 정확한 AI 코디를 받을 수 있어요.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 24),
                Text('무드 선택 (복수 가능)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 20) / 3;
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(_moods.length, (i) {
                        final m = _moods[i];
                        final selected = _selectedMoods.contains(i);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (selected) _selectedMoods.remove(i);
                            else _selectedMoods.add(i);
                          }),
                          child: Container(
                            width: width - 4,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: m.$3,
                              borderRadius: BorderRadius.circular(12),
                              border: selected ? Border.all(color: Colors.black87, width: 2) : null,
                            ),
                            child: Column(
                              children: [
                                Icon(m.$2, size: 24, color: selected ? Colors.black87 : Colors.grey[700]),
                                const SizedBox(height: 6),
                                Text(m.$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800])),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text('선호 스타일 키워드', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_styleKeywords.length, (i) {
                    final selected = _selectedStyles.contains(i);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selected) _selectedStyles.remove(i);
                        else _selectedStyles.add(i);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? Colors.black87 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? Colors.black87 : Colors.grey[400]!),
                        ),
                        child: Text(
                          _styleKeywords[i],
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : Colors.grey[700]),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: widget.onSave,
                    icon: const Text('◆', style: TextStyle(color: Colors.white)),
                    label: const Text('설정 저장하고 AI 코디 받기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
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

class _AddItemModal extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onUploadFromGallery;
  final VoidCallback onTakePhoto;
  final VoidCallback onSearchGoogle;

  const _AddItemModal({
    required this.onDismiss,
    required this.onUploadFromGallery,
    required this.onTakePhoto,
    required this.onSearchGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '새 아이템 추가',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            '나에게 가장 잘 맞는 방법을 선택하세요',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          _AddItemOption(
            icon: Icons.photo_library_outlined,
            iconColor: Colors.orange[400]!,
            label: '갤러리에서 업로드',
            onTap: onUploadFromGallery,
          ),
          _AddItemOption(
            icon: Icons.camera_alt_outlined,
            iconColor: Colors.pink[400]!,
            label: '사진 찍기',
            onTap: onTakePhoto,
          ),
          _AddItemOption(
            icon: Icons.search,
            iconColor: Colors.purple[400]!,
            label: '라이브러리에서 검색',
            onTap: onSearchGoogle,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AddItemOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _AddItemOption({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
