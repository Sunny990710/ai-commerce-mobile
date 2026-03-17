import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/product.dart';
import 'item_advice_screen.dart';

/// 아이템 분석 로딩 화면 - 분석 중 표시 후 결과 화면으로 전환
class ItemAdviceLoadingScreen extends StatefulWidget {
  final String itemImageUrl;
  final String itemBrand;
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final VoidCallback onClose;

  const ItemAdviceLoadingScreen({
    super.key,
    required this.itemImageUrl,
    required this.itemBrand,
    required this.wishIds,
    required this.onToggleWish,
    required this.onClose,
  });

  @override
  State<ItemAdviceLoadingScreen> createState() => _ItemAdviceLoadingScreenState();
}

class _ItemAdviceLoadingScreenState extends State<ItemAdviceLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..addListener(() {
        setState(() => _progress = _progressController.value);
      });

    _progressController.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ItemAdviceScreen(
            itemImageUrl: widget.itemImageUrl,
            itemBrand: widget.itemBrand,
            wishIds: widget.wishIds,
            onToggleWish: widget.onToggleWish,
            onClose: widget.onClose,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round().clamp(0, 100);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                onPressed: () => widget.onClose(),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCharacter(),
                    const SizedBox(height: 24),
                    Text(
                      '분석 중 $percent%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 온보딩 ai_stylist_intro_screen과 동일한 아이콘 사용 (gradient 원형 + Icons.face)
  Widget _buildCharacter() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            size: const Size(140, 140),
            painter: _WavePainter(progress: _progress),
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade100,
                Colors.blue.shade200,
              ],
            ),
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.face, size: 80, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;

  _WavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final waveHeight = 14.0 * (1 - progress * 0.4);
    final startY = size.height * 0.55;
    final path = Path();
    path.moveTo(0, startY);
    for (double x = 0; x <= size.width; x += 3) {
      final t = x / size.width * math.pi * 2 + progress * math.pi * 2;
      final y = startY + waveHeight * (0.5 + 0.5 * math.sin(t));
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..color = const Color(0xFFB3D9FF).withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
