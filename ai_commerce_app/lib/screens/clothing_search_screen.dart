import 'package:flutter/material.dart';

/// 구글 검색 UI 모형 화면 (실제 연동 없음)
/// 검색창, 카테고리, 필터, 상품 그리드를 표시합니다.
class ClothingSearchScreen extends StatefulWidget {
  final String initialQuery;

  const ClothingSearchScreen({super.key, this.initialQuery = ''});

  @override
  State<ClothingSearchScreen> createState() => _ClothingSearchScreenState();
}

class _ClothingSearchScreenState extends State<ClothingSearchScreen> {
  int _selectedCategoryIndex = 0;
  bool _showInfoBanner = true;

  static const _categories = ['전체', '상의', '원피스', '바지', '치마', '아우터', '신발', '가방'];
  static const _filters = ['브랜드', '색상', '소재', '패턴'];

  static const _mockProducts = [
    ('RAINBOW K', '골드 반지'),
    ('VERSACE', '메두사 반지'),
    ('AUXILIARY', '베이지 페도라'),
    ('SYDNEY EVAN', '멀티 젬 반지'),
    ('H&M', '니트 스웨터'),
    ('ZARA', '데님 재킷'),
  ];

  /// Unsplash 패션/의류 이미지 URL 목록
  static const _unsplashImages = [
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400', // 데님 재킷
    'https://images.unsplash.com/photo-1576566588028-4147f3845f81?w=400', // 니트
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', // 스니커즈
    'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400', // 가방
    'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400', // 코트
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400', // 자켓
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: _buildSearchBar(),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          _buildFilterRow(),
          Expanded(
            child: _buildProductGrid(),
          ),
          if (_showInfoBanner) _buildInfoBanner(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final query = widget.initialQuery.isEmpty ? 'SPAO 여성 라운드넥 가디건' : widget.initialQuery;
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.search, size: 22, color: Colors.grey),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                query,
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Icon(Icons.camera_alt_outlined, size: 22, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories.length, (i) {
            final selected = i == _selectedCategoryIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = i),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selected ? Colors.black87 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
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
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ..._filters.map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(f, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[600]),
                ],
              ),
            ),
          )),
          const Spacer(),
          Icon(Icons.tune, size: 22, color: Colors.grey[700]),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: _mockProducts.length,
      itemBuilder: (context, index) {
        final product = _mockProducts[index];
        return _ProductCard(
          brand: product.$1,
          imageUrl: _unsplashImages[index % _unsplashImages.length],
          onAddTap: () {},
        );
      },
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 22, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '컬러, 패턴, 카테고리를 조합해 더 쉽게 아이템을 찾아보세요.',
              style: TextStyle(fontSize: 14, color: Colors.blue[900]),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _showInfoBanner = false),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String brand;
  final String imageUrl;
  final VoidCallback onAddTap;

  const _ProductCard({required this.brand, required this.imageUrl, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
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
                      errorBuilder: (_, __, ___) => Icon(Icons.checkroom, size: 48, color: Colors.grey[400]),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: const Icon(Icons.add, size: 18, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Text(
              brand,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
