import 'package:flutter/material.dart';
import '../constants/mock_data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;

  const WishlistScreen({super.key, required this.wishIds, required this.onToggleWish});

  @override
  Widget build(BuildContext context) {
    final wishProducts = mockProducts.where((p) => wishIds.contains(p.id)).toList();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('위시리스트', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: wishProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('저장한 상품이 없어요', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('마음에 드는 상품을 저장해 보세요', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: wishProducts.length,
              itemBuilder: (_, i) {
                final p = wishProducts[i];
                return ProductCard(
                  product: p,
                  isWished: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p, wishIds: wishIds, onToggleWish: onToggleWish))),
                  onWish: () => onToggleWish(p),
                );
              },
            ),
    );
  }
}
