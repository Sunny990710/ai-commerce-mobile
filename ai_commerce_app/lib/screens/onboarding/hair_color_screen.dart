import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingHairColorScreen extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingHairColorScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    ('금발', Color(0xFFF5D76E)),
    ('갈색 머리', Color(0xFF8B4513)),
    ('짙은 갈색/검은 머리', Color(0xFF2C1810)),
    ('빨간 머리', Color(0xFFB22222)),
    ('회색/은색 머리', Color(0xFF808080)),
    ('기타', Colors.transparent),
    ('잘 모르겠어요', Colors.transparent),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '현재 헤어 컬러를 알려주세요',
      progress: 0.55,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      child: ListView(
        shrinkWrap: true,
        children: options.map((o) => ListTile(
          leading: o.$2 == Colors.transparent
              ? Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6)),
                  child: o.$1 == '기타' ? const Icon(Icons.more_horiz, size: 20) : const Icon(Icons.help_outline, size: 20),
                )
              : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: o.$2, borderRadius: BorderRadius.circular(6)),
                ),
          title: Text(o.$1, style: const TextStyle(fontSize: 16)),
          trailing: Icon(Icons.check, color: selected == o.$1 ? Colors.blue : Colors.grey[300], size: 22),
          onTap: () => onSelect(o.$1),
          contentPadding: EdgeInsets.zero,
        )).toList(),
      ),
    );
  }
}
