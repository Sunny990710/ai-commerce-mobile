import 'package:flutter/material.dart';

void _showOtherMethodsSheet(BuildContext context, {required VoidCallback onKakao, required VoidCallback onEmail}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Text('다른 방법으로 시작하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _OtherMethodButton(
                  label: '카카오로 시작하기',
                  color: const Color(0xFFFEE500),
                  textColor: Colors.black87,
                  icon: _KakaoIcon(),
                  onPressed: () {
                    Navigator.pop(ctx);
                    onKakao();
                  },
                ),
                const SizedBox(height: 12),
                _OtherMethodButton(
                  label: '이메일로 시작하기',
                  color: Colors.white,
                  textColor: Colors.black87,
                  icon: Icon(Icons.email_outlined, size: 24, color: Colors.grey[600]),
                  onPressed: () {
                    Navigator.pop(ctx);
                    onEmail();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

class _OtherMethodButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  const _OtherMethodButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasBorder = color == Colors.white;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24, height: 24, child: icon),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }
}

class OnboardingSignupScreen extends StatelessWidget {
  final VoidCallback onKakao;
  final VoidCallback onGoogle;
  final VoidCallback onOther;
  final VoidCallback onLogin;
  final VoidCallback onBrowse;
  final VoidCallback? onClose;

  const OnboardingSignupScreen({
    super.key,
    required this.onKakao,
    required this.onGoogle,
    required this.onOther,
    required this.onLogin,
    required this.onBrowse,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black87), onPressed: () => (onClose ?? () => Navigator.of(context).pop())()),
        title: const Text('회원가입', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _SocialButton(
                label: '카카오로 시작하기',
                color: const Color(0xFFFEE500),
                textColor: Colors.black87,
                icon: _KakaoIcon(),
                onPressed: onKakao,
              ),
              const SizedBox(height: 12),
              _SocialButtonWithGradientBorder(
                label: '구글로 시작하기',
                textColor: Colors.black87,
                icon: _GoogleIcon(),
                onPressed: onGoogle,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => _showOtherMethodsSheet(context, onKakao: onKakao, onEmail: onOther),
                child: const Text('다른 방법으로 시작하기 >', style: TextStyle(color: Colors.black54)),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: onLogin, child: const Text('로그인', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black54))),
                  const Text(' | ', style: TextStyle(color: Colors.black38)),
                  TextButton(onPressed: onBrowse, child: const Text('둘러보기', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black54))),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24, height: 24, child: icon),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SocialButtonWithGradientBorder extends StatelessWidget {
  final String label;
  final Color textColor;
  final Widget icon;
  final VoidCallback onPressed;

  const _SocialButtonWithGradientBorder({
    required this.label,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.5),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10.5),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 24, height: 24, child: icon),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KakaoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _KakaoLogoPainter(),
      ),
    );
  }
}

class _KakaoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 노란색 배경 (둥근 사각형)
    final bgPaint = Paint()..color = const Color(0xFFFAE100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(4)),
      bgPaint,
    );

    // 검정 말풍선 (몸통: 둥근 사각형)
    final bubblePaint = Paint()..color = Colors.black;
    final bubbleRect = Rect.fromLTWH(w * 0.18, h * 0.15, w * 0.64, h * 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(2)),
      bubblePaint,
    );

    // 말풍선 꼬리 (아래 왼쪽을 향한 삼각형)
    final tailPath = Path()
      ..moveTo(w * 0.35, h * 0.65)
      ..lineTo(w * 0.48, h * 0.85)
      ..lineTo(w * 0.58, h * 0.65)
      ..close();
    canvas.drawPath(tailPath, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://www.google.com/favicon.ico',
      width: 24,
      height: 24,
      errorBuilder: (_, __, ___) => const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4285F4))),
    );
  }
}
