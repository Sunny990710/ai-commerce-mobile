import 'package:flutter/material.dart';
import '../constants/mock_data.dart';
import '../models/product.dart';
import '../utils/wishlist_popup.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final void Function(String prompt)? onGoToChat;
  final VoidCallback? onGoToMy;
  final VoidCallback? onGoToWishlist;

  const HomeScreen({
    super.key,
    required this.wishIds,
    required this.onToggleWish,
    this.onGoToChat,
    this.onGoToMy,
    this.onGoToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('NightDream', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: onGoToMy,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlidingCards(context),
                  const SizedBox(height: 24),
                  _buildRealtimeBestSection(context),
                  const SizedBox(height: 24),
                  _buildPopularBrandsSection(),
                  const SizedBox(height: 24),
                  const Text('지금 뜨는 아이템', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('AI가 추천하는 인기 아이템', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.56,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final p = mockProducts[i];
                  return ProductCard(
                    product: p,
                    isWished: wishIds.contains(p.id),
                    colorOptions: productColorOptions[p.id],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p, wishIds: wishIds, onToggleWish: onToggleWish))),
                    onWish: () {
                      final wasAdding = !wishIds.contains(p.id);
                      onToggleWish(p);
                      if (wasAdding && onGoToWishlist != null) {
                        showWishlistAddedPopup(context, onGoToWishlist!);
                      }
                    },
                  );
                },
                childCount: mockProducts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

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

  static const _popularBrands = ['스파오', '미쏘', '자라', '뉴발란스', '헤지스', '키디키디', '시슬리', '타임'];

  Widget _buildRealtimeBestSection(BuildContext context) {
    final products = mockProducts.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('실시간 베스트', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('전체보기', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Icon(Icons.chevron_right, size: 18, color: Colors.grey[600]),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = products[i];
              return SizedBox(
                width: 130,
                child: _RealtimeBestCard(
                  product: p,
                  rank: i + 1,
                  isWished: wishIds.contains(p.id),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p, wishIds: wishIds, onToggleWish: onToggleWish))),
                  onWish: () {
                    final wasAdding = !wishIds.contains(p.id);
                    onToggleWish(p);
                    if (wasAdding && onGoToWishlist != null) {
                      showWishlistAddedPopup(context, onGoToWishlist!);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularBrandsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('인기 브랜드', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('전체보기', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Icon(Icons.chevron_right, size: 18, color: Colors.grey[600]),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _popularBrands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final brand = _popularBrands[i];
              final logoPath = _brandLogos[brand];
              return GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                      ),
                      child: logoPath != null
                          ? ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(logoPath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.store, color: Colors.grey[400])),
                              ),
                            )
                          : Icon(Icons.store, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 6),
                    Text(brand, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlidingCards(BuildContext context) {
    const cards = [
      (
        backgroundColor: Color(0xFFE8D5E7),
        icon: Icons.auto_awesome,
        title: '스타일 취향을 알아보세요.',
        description: 'AI가 당신의 취향을 분석해 맞춤 스타일을 제안해 드려요.',
        prompt: '내 스타일 취향 알아보기',
      ),
      (
        backgroundColor: Color(0xFFD5E5E8),
        icon: Icons.checkroom,
        title: '내 체형에 잘 어울리는 핏을 찾아보세요.',
        description: '체형에 맞는 핏과 실루엣을 추천받아 보세요.',
        prompt: '내 체형에 잘 어울리는 핏 찾기',
      ),
      (
        backgroundColor: Color(0xFFE5E8D5),
        icon: Icons.trending_up,
        title: '요즘 패션 트렌드를 둘러보세요.',
        description: '지금 뜨는 트렌드와 스타일을 만나보세요.',
        prompt: '요즘 패션 트렌드 둘러보기',
      ),
      (
        backgroundColor: Color(0xFFF5E6D3),
        icon: Icons.palette_outlined,
        title: '나에게 잘 어울리는 컬러를 찾아보세요.',
        description: '퍼스널 컬러 기반 컬러 추천을 받아보세요.',
        prompt: '나에게 가장 잘 어울리는 컬러 찾기',
      ),
    ];

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 0, right: 8),
        itemCount: cards.length,
        itemBuilder: (_, i) {
          final c = cards[i];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _SlidingCard(
              backgroundColor: c.backgroundColor,
              icon: c.icon,
              title: c.title,
              description: c.description,
              prompt: c.prompt,
              onPromptTap: (prompt) => onGoToChat?.call(prompt),
            ),
          );
        },
      ),
    );
  }
}

class _RealtimeBestCard extends StatelessWidget {
  final Product product;
  final int rank;
  final bool isWished;
  final VoidCallback? onTap;
  final VoidCallback? onWish;

  const _RealtimeBestCard({
    required this.product,
    required this.rank,
    required this.isWished,
    this.onTap,
    this.onWish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image)),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                    child: Center(child: Text('$rank', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
                if (onWish != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onWish,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                        child: Icon(isWished ? Icons.favorite : Icons.favorite_border, size: 16, color: isWished ? Colors.red : Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(product.brand, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          Text(product.name, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Row(
            children: [
              if (product.originalPrice > 0 && product.originalPrice > product.price)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text('${(100 - (product.price / product.originalPrice * 100)).round()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red[400])),
                ),
              Text(product.formattedPrice, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlidingCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String description;
  final String prompt;
  final void Function(String prompt)? onPromptTap;

  const _SlidingCard({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.prompt,
    this.onPromptTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: GestureDetector(
        onTap: () => onPromptTap?.call(prompt),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.black87, size: 20),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.black87.withOpacity(0.8)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        prompt,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.send, size: 16, color: Colors.white),
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
