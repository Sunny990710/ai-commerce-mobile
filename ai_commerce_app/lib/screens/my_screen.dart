import 'package:flutter/material.dart';

import '../models/product.dart';
import 'my_style_profile_screen.dart';
import 'wishlist_screen.dart';

class MyScreen extends StatelessWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final Future<void> Function() onResetOnboarding;

  const MyScreen({super.key, required this.wishIds, required this.onToggleWish, required this.onResetOnboarding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('마이', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.purple[100], child: Icon(Icons.person, color: Colors.purple[700])),
              title: const Text('내 스타일 프로필', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('AI 추천을 위한 프로필 설정', style: TextStyle(color: Colors.grey[600])),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const MyStyleProfileScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.refresh, color: Colors.orange[700]),
              title: const Text('온보딩 다시 보기', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('개인화 설정을 처음부터 다시 진행해요', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await onResetOnboarding();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('온보딩 화면으로 이동했어요')));
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite_border, color: Colors.red[300]),
              title: const Text('저장한 상품'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WishlistScreen(wishIds: wishIds, onToggleWish: onToggleWish))),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.shopping_bag_outlined, color: Colors.grey[700]),
              title: const Text('주문 내역'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('주문 내역은 준비 중이에요'))),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_shipping_outlined, color: Colors.grey[700]),
              title: const Text('배송 조회'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('배송 조회는 준비 중이에요'))),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.settings_outlined, color: Colors.grey[700]),
              title: const Text('설정'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('설정 화면은 준비 중이에요'))),
            ),
          ),
        ],
      ),
    );
  }
}
