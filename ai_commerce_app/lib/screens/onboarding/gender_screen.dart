import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingGenderScreen extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final bool showSkip;

  const OnboardingGenderScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    this.showSkip = true,
  });

  static const options = ['여자', '남자', '밝히고 싶지 않아요'];

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '성별이 무엇인가요?',
      progress: 0.1,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      showSkip: showSkip,
      child: ListView(
        shrinkWrap: true,
        children: options.map((o) => _OptionTile(
          label: o,
          selected: selected == o,
          onTap: () => onSelect(o),
        )).toList(),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: TextStyle(fontSize: 16, color: selected ? Colors.blue : Colors.black87)),
      trailing: Icon(Icons.check, color: selected ? Colors.blue : Colors.grey[300], size: 22),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
