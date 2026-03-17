import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingColorToneScreen extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingColorToneScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    '밝고 따뜻한 색감',
    '깊고 차분한 색감',
    '시원하고 부드러운 색감',
    '깨끗하고 선명한 색감',
    '잘 모르겠어요',
  ];

  static const Map<String, List<Color>> _colorPalettes = {
    '밝고 따뜻한 색감': [
      Color(0xFFFFB5A7), // coral
      Color(0xFFF9D5BB), // peach
      Color(0xFFE8B4B8), // dusty rose
    ],
    '깊고 차분한 색감': [
      Color(0xFFC17F59), // terracotta
      Color(0xFF8B7355), // brown
      Color(0xFF6B5B4D), // olive brown
    ],
    '시원하고 부드러운 색감': [
      Color(0xFF87CEEB), // sky blue
      Color(0xFFE8D5E4), // dusty pink
      Color(0xFF98D4BB), // sage
    ],
    '깨끗하고 선명한 색감': [
      Color(0xFFE63946), // true red
      Color(0xFF1D3557), // navy
      Color(0xFF457B9D), // clear blue
    ],
  };

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '평소 어떤 컬러톤이 가장 잘 어울린다고 느끼시나요?',
      progress: 0.5,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      child: ListView(
        shrinkWrap: true,
        children: options.map((o) {
          final palette = _colorPalettes[o];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              label: o,
              selected: selected == o,
              onTap: () => onSelect(o),
              palette: palette,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final List<Color>? palette;

  const _OptionCard({
    required this.label,
    required this.selected,
    required this.onTap,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF1976D2) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected ? const Color(0xFF1976D2) : Colors.black87,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            if (palette != null) _ColorPaletteStrip(colors: palette!),
          ],
        ),
      ),
    );
  }
}

class _ColorPaletteStrip extends StatelessWidget {
  final List<Color> colors;

  const _ColorPaletteStrip({required this.colors});

  @override
  Widget build(BuildContext context) {
    const double size = 32;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: colors.map((c) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(
              color: c.computeLuminance() > 0.7 ? Colors.grey.shade400 : Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
