import 'package:flutter/material.dart';

class AiStylistModal extends StatelessWidget {
  final VoidCallback onDismiss;

  const AiStylistModal({super.key, required this.onDismiss});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AiStylistModal(onDismiss: () => Navigator.pop(ctx)),
    );
  }

  static const options = [
    (Icons.auto_awesome, '내 스타일 취향 알아보기'),
    (Icons.checkroom, '내 체형에 잘 어울리는 핏 찾기'),
    (Icons.trending_up, '요즘 패션 트렌드 둘러보기'),
    (Icons.palette_outlined, '나에게 가장 잘 어울리는 컬러 찾기'),
  ];

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
          Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Text(
            'AI 스타일리스트의 도움을 받아볼까요?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...options.map((o) => _OptionTile(icon: o.$1, label: o.$2)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onDismiss,
              child: const Text('괜찮아요', style: TextStyle(fontSize: 16, color: Colors.black54)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OptionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 24),
      title: Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
