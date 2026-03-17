import 'package:flutter/material.dart';

import 'skip_confirm_dialog.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingWelcomeScreen({super.key, required this.onNext, required this.onSkip, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: onBack ?? () => Navigator.of(context).pop()),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await OnboardingSkipConfirmDialog.show(context);
              if (confirmed == true && context.mounted) onSkip();
            },
            child: const Text('건너뛰기', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                '시작하기 전에,',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '당신에 대해 알고 싶어요!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Icon(Icons.face, size: 120, color: Colors.blue.shade200),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('네, 좋아요'),
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
