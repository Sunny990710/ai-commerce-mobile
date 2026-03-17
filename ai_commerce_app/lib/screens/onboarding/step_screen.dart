import 'package:flutter/material.dart';

class OnboardingStepScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final double progress;
  final bool nextEnabled;
  final bool showSkip;
  final double spacingAfterTitle;
  final double? horizontalPadding;

  const OnboardingStepScreen({
    super.key,
    required this.title,
    required this.child,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    this.progress = 0,
    this.nextEnabled = true,
    this.showSkip = true,
    this.spacingAfterTitle = 24,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final padding = horizontalPadding != null
        ? EdgeInsets.symmetric(horizontal: horizontalPadding!, vertical: 24)
        : const EdgeInsets.all(24);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: onBack ?? () => Navigator.of(context).pop()),
        actions: showSkip
            ? [
                TextButton(onPressed: onSkip, child: const Text('건너뛰기', style: TextStyle(color: Colors.black54))),
              ]
            : null,
        bottom: progress > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation(Colors.black87)),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: spacingAfterTitle),
              Expanded(child: child),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: nextEnabled ? onNext : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
