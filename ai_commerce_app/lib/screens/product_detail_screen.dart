import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;

  const ProductDetailScreen({super.key, required this.product, required this.wishIds, required this.onToggleWish});

  @override
  Widget build(BuildContext context) {
    final isWished = wishIds.contains(product.id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported, size: 48)),
              ),
            ),
            actions: [
              IconButton(icon: Icon(isWished ? Icons.favorite : Icons.favorite_border, color: isWished ? Colors.red : null), onPressed: () => onToggleWish(product)),
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                  const SizedBox(height: 4),
                  Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (product.originalPrice > 0)
                        Text(product.formattedOriginalPrice, style: TextStyle(fontSize: 14, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
                      if (product.originalPrice > 0) const SizedBox(width: 8),
                      Text(product.formattedPrice, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (product.discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                          child: Text('${product.discountPercent}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red[700])),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('AI 추천 이유', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.purple[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${product.tag.isNotEmpty ? product.tag + " · " : ""}가격 대비 가치가 좋고, 다양한 스타일과 매치하기 좋은 아이템이에요.',
                            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('리뷰 요약', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('사이즈는 정사이즈로 구매하면 적당하다는 평이 많아요. 소재가 부드럽고 실물이 사진보다 예쁘다는 리뷰가 많습니다.', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('장바구니'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('구매하기 기능은 준비 중이에요')));
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('바로 구매'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
