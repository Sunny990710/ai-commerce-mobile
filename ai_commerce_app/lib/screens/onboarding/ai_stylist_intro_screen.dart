import 'package:flutter/material.dart';

class OnboardingAiStylistIntroScreen extends StatelessWidget {
  final String? nickname;
  final VoidCallback onContinue;
  final VoidCallback? onBack;

  const OnboardingAiStylistIntroScreen({
    super.key,
    this.nickname,
    required this.onContinue,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final name = (nickname ?? '').trim().isNotEmpty ? nickname!.trim() : '회원';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 32),
                      const Text(
                        '만나서 반가워요!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '저는 AI 스타일리스트, 😉이라고 해요. $name님의 취향과 스타일을 알려주시면, 더 잘 어울리는 제품을 추천해드릴게요.',
                        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('계속하기'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
