import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingStyleScreen extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingStyleScreen({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    '캐주얼', '시크', '페미닌', '미니멀', '오피스', '스트릿', '스포티', '빈티지', 'Y2K', '잘 모르겠어요',
  ];

  static const _styleImages = {
    '캐주얼': 'https://images.unsplash.com/photo-1578681994506-b8f463449011?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    '시크': 'https://images.unsplash.com/photo-1675215452934-ab9954f0aa78?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    '페미닌': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=400&q=80',
    '미니멀': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=80',
    '오피스': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=400&q=80',
    '스트릿': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=400&q=80',
    '스포티': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=400&q=80',
    '빈티지': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=400&q=80',
    'Y2K': 'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=400&q=80',
    '잘 모르겠어요': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=400&q=80',
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '평소 선호하는 스타일을 선택해주세요',
      progress: 0.45,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
        children: options.map((o) => _OptionCard(
          label: o,
          imageUrl: _styleImages[o],
          selected: selected.contains(o),
          onTap: () => onToggle(o),
        )).toList(),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({required this.label, this.imageUrl, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.checkroom, size: 48, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.checkroom, size: 48, color: Colors.grey),
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              color: selected ? Colors.blue.shade50 : Colors.white,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? Colors.blue.shade700 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
