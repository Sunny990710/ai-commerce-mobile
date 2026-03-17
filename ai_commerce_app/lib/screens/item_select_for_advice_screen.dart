import 'package:flutter/material.dart';

import '../models/product.dart';
import 'item_advice_loading_screen.dart';

/// 아이템 조언 시 옷장에서 선택할 수 있는 그리드 화면
class ItemSelectForAdviceScreen extends StatefulWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;

  const ItemSelectForAdviceScreen({
    super.key,
    required this.wishIds,
    required this.onToggleWish,
  });

  @override
  State<ItemSelectForAdviceScreen> createState() => _ItemSelectForAdviceScreenState();
}

class _ItemSelectForAdviceScreenState extends State<ItemSelectForAdviceScreen> {
  static const _categories = ['전체', '상의', '원피스', '바지', '치마', '아우터', '신발', '가방'];
  int _selectedCategoryIndex = 0;

  static const _items = [
    _ClosetItem(brand: 'No Brand', date: '2026. 3. 16.', category: '상의'),
    _ClosetItem(brand: 'AGNESB', date: '2026. 3. 16.', category: '상의'),
    _ClosetItem(brand: 'BALENCIAGA', date: '2026. 3. 16.', category: '신발'),
    _ClosetItem(brand: 'RAINS', date: '2026. 3. 16.', category: '가방'),
    _ClosetItem(brand: 'H&M', date: '2026. 3. 16.', category: '아우터'),
    _ClosetItem(brand: '스파오', date: '2026. 3. 16.', category: '상의'),
    _ClosetItem(brand: '미쏘', date: '2026. 3. 16.', category: '원피스'),
    _ClosetItem(brand: '자라', date: '2026. 3. 16.', category: '바지'),
  ];

  static const _images = [
    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
    'https://images.unsplash.com/photo-1576566588028-4147f3845f81?w=400',
    'https://images.unsplash.com/photo-1542291026-7ec264c27ff?w=400',
    'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400',
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400',
  ];

  List<_ClosetItem> get _filteredItems {
    final cat = _categories[_selectedCategoryIndex];
    if (cat == '전체') return _items;
    return _items.where((i) => i.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('아이템 선택', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _buildCategoryTabs(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _AddCard(
                      onTap: () => Navigator.pop(context),
                    );
                  }
                  final item = items[index - 1];
                  final itemIndex = _items.indexOf(item);
                  final imageUrl = _images[itemIndex % _images.length];
                  return _ItemCard(
                    brand: item.brand,
                    date: item.date,
                    imageUrl: imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemAdviceLoadingScreen(
                            itemImageUrl: imageUrl,
                            itemBrand: item.brand,
                            wishIds: widget.wishIds,
                            onToggleWish: widget.onToggleWish,
                            onClose: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
}

class _ClosetItem {
  final String brand;
  final String date;
  final String category;
  const _ClosetItem({required this.brand, required this.date, required this.category});
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF64B5F6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 40, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text('추가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue[700])),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String brand;
  final String date;
  final String imageUrl;
  final VoidCallback onTap;

  const _ItemCard({
    required this.brand,
    required this.date,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.checkroom, size: 32, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(brand, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                  Text(date, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
