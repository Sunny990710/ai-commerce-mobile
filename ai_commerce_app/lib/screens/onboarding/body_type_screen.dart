import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingBodyTypeScreen extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingBodyTypeScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    ('잘 모르겠어요', Icons.help_outline),
    ('모래시계형', Icons.hourglass_empty),
    ('삼각형', null),
    ('역삼각형', null),
    ('둥근형', Icons.radio_button_unchecked),
    ('직사각형', Icons.crop_square),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '체형을 알려주세요',
      progress: 0.6,
      onNext: onNext,
      onSkip: onSkip,
      onBack: onBack,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: options.map((o) {
          return _OptionCard(
            label: o.$1,
            icon: o.$2,
            iconSize: 36,
            selected: selected == o.$1,
            onTap: () => onSelect(o.$1),
            isInvertedTriangle: o.$1 == '역삼각형',
          );
        }).toList(),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final double iconSize;
  final bool selected;
  final VoidCallback onTap;
  final bool isInvertedTriangle;

  const _OptionCard({
    required this.label,
    required this.icon,
    this.iconSize = 36,
    required this.selected,
    required this.onTap,
    this.isInvertedTriangle = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.blue : Colors.grey;
    final displayIcon = icon != null
        ? Icon(icon, size: iconSize, color: color)
        : _OutlineTriangle(
            size: iconSize,
            color: color,
            pointDown: isInvertedTriangle,
          );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade50,
          border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayIcon,
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _OutlineTriangle extends StatelessWidget {
  final double size;
  final Color color;
  final bool pointDown;

  const _OutlineTriangle({
    required this.size,
    required this.color,
    this.pointDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OutlineTrianglePainter(color: color, pointDown: pointDown),
      ),
    );
  }
}

class _OutlineTrianglePainter extends CustomPainter {
  final Color color;
  final bool pointDown;

  _OutlineTrianglePainter({required this.color, required this.pointDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    if (pointDown) {
      path.moveTo(size.width * 0.5, size.height * 0.1);
      path.lineTo(size.width * 0.9, size.height * 0.9);
      path.lineTo(size.width * 0.1, size.height * 0.9);
    } else {
      path.moveTo(size.width * 0.5, size.height * 0.9);
      path.lineTo(size.width * 0.1, size.height * 0.1);
      path.lineTo(size.width * 0.9, size.height * 0.1);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OutlineTrianglePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pointDown != pointDown;
}
