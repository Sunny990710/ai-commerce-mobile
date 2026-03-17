import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isBestPick;
  final bool isWished;
  final VoidCallback? onTap;
  final VoidCallback? onWish;

  const ProductCard({
    super.key,
    required this.product,
    this.isBestPick = false,
    this.isWished = false,
    this.onTap,
    this.onWish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 3.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
              if (isBestPick)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                    child: const Text('Best Pick', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (product.tag.isNotEmpty && !isBestPick)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(6)),
                    child: Text(product.tag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (onWish != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWish,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                      child: Icon(isWished ? Icons.favorite : Icons.favorite_border, size: 18, color: isWished ? Colors.red : Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(product.brand, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          Text(product.name, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Row(
            children: [
              if (product.originalPrice > 0)
                Text(product.formattedOriginalPrice, style: TextStyle(fontSize: 10, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
              if (product.originalPrice > 0) const SizedBox(width: 4),
              Flexible(child: Text(product.formattedPrice, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }
}
