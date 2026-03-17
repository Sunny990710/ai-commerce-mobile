import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingPriceRangeScreen extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingPriceRangeScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    '저가 브랜드',
    '중가 브랜드',
    '프리미엄 브랜드',
    '럭셔리 브랜드',
    '잘 모르겠어요',
  ];

  static const Map<String, List<({String? label, Color? color, String? imagePath})>> _brandBadges = {
    '저가 브랜드': [
      (label: null, color: null, imagePath: 'assets/images/spao_logo.png'),
      (label: null, color: null, imagePath: 'assets/images/topten_logo.png'),
      (label: '에잇세컨즈', color: Color(0xFFE53935), imagePath: null),
    ],
    '중가 브랜드': [
      (label: 'Zara', color: Color(0xFF212121), imagePath: null),
      (label: 'Nepa', color: Color(0xFF757575), imagePath: null),
      (label: 'Kodak', color: Color(0xFF1976D2), imagePath: null),
    ],
    '프리미엄 브랜드': [
      (label: 'COS', color: Color(0xFF212121), imagePath: null),
      (label: '파타고니아', color: Color(0xFF2E7D32), imagePath: null),
      (label: '룰루레몬', color: Color(0xFF37474F), imagePath: null),
    ],
    '럭셔리 브랜드': [
      (label: 'BV', color: Color(0xFF1B5E20), imagePath: null),
      (label: '마르지엘라', color: Color(0xFF212121), imagePath: null),
      (label: '자크뮈스', color: Color(0xFF424242), imagePath: null),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '주로 어떤 가격대의 브랜드를 선호하세요?',
      progress: 0.48,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      child: ListView(
        shrinkWrap: true,
        children: options.map((opt) {
          final isSelected = selected == opt;
          final brands = _brandBadges[opt];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => onSelect(opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      opt,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? const Color(0xFF1976D2) : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    if (brands != null)
                      _BrandBadgeStack(brands: brands)
                    else
                      Icon(Icons.check, color: isSelected ? const Color(0xFF1976D2) : Colors.grey[300], size: 22),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BrandBadgeStack extends StatelessWidget {
  final List<({String? label, Color? color, String? imagePath})> brands;

  const _BrandBadgeStack({required this.brands});

  @override
  Widget build(BuildContext context) {
    const double size = 32;

    return Wrap(
      spacing: 4,
      runSpacing: 0,
      children: brands.map((b) {
        final useImage = b.imagePath != null;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: useImage ? Colors.transparent : (b.color ?? Colors.grey),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: useImage
              ? ClipOval(
                  child: Image.asset(
                    b.imagePath!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      b.label ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        );
      }).toList(),
    );
  }
}
