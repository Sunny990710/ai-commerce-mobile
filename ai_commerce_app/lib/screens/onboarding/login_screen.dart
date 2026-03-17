import 'package:flutter/material.dart';

class OnboardingLoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onClose;

  const OnboardingLoginScreen({
    super.key,
    required this.onLogin,
    required this.onClose,
  });

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canLogin => _emailController.text.trim().isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: widget.onClose,
        ),
        centerTitle: true,
        title: const Text('로그인', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '이메일 입력',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1.5)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호 입력',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1.5)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _canLogin ? () => widget.onLogin() : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _canLogin ? Colors.black87 : Colors.grey.shade300,
                    foregroundColor: _canLogin ? Colors.white : Colors.grey.shade600,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('로그인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이메일 · 아이디찾기'))),
                    child: Text('이메일 ㆍ 아이디찾기', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                  ),
                  Text(' | ', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('비밀번호찾기'))),
                    child: Text('비밀번호찾기', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIconButton(
                    color: const Color(0xFFFEE500),
                    icon: _KakaoIcon(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  _SocialIconButton(
                    color: const Color(0xFF03C75A),
                    icon: const Text('N', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  _SocialIconButton(
                    color: Colors.white,
                    icon: _GoogleIcon(),
                    onPressed: () {},
                    withBorder: true,
                  ),
                  const SizedBox(width: 16),
                  _SocialIconButton(
                    color: const Color(0xFF1877F2),
                    icon: const Text('f', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('계정이 없으신가요? 회원가입'))),
                child: Text('계정이 없으신가요? 회원가입', style: TextStyle(fontSize: 14, color: Colors.grey[700], decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final Color color;
  final Widget icon;
  final VoidCallback onPressed;
  final bool withBorder;

  const _SocialIconButton({required this.color, required this.icon, required this.onPressed, this.withBorder = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: withBorder ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Center(child: icon),
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
    final bgPaint = Paint()..color = const Color(0xFFFAE100);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(4)),
      bgPaint,
    );
    final bubblePaint = Paint()..color = Colors.black;
    final bubbleRect = Rect.fromLTWH(w * 0.18, h * 0.15, w * 0.64, h * 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleRect, const Radius.circular(2)),
      bubblePaint,
    );
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
