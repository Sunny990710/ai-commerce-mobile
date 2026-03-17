import 'package:flutter/material.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  final VoidCallback onStart;

  const OnboardingCompleteScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 16, spreadRadius: 2)],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                '모두 완료',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                '이제 AI 스타일리스트가 회원님의 정보를 바탕으로 맞춤 팁을 제공해 드려요.',
                style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('NightDream 시작하기'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
