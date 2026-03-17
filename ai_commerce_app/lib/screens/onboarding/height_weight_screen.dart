import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingHeightWeightScreen extends StatefulWidget {
  final String? heightCm;
  final String? weightKg;
  final ValueChanged<String> onHeightChanged;
  final ValueChanged<String> onWeightChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final bool showSkip;

  const OnboardingHeightWeightScreen({
    super.key,
    required this.heightCm,
    required this.weightKg,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    this.showSkip = true,
  });

  @override
  State<OnboardingHeightWeightScreen> createState() => _OnboardingHeightWeightScreenState();
}

class _OnboardingHeightWeightScreenState extends State<OnboardingHeightWeightScreen> {
  late final _heightController = TextEditingController(text: widget.heightCm ?? '');
  late final _weightController = TextEditingController(text: widget.weightKg ?? '');

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '키/몸무게를 알려주세요',
      progress: 0.3,
      onNext: widget.onNext,
      onSkip: widget.onSkip,
      onBack: widget.onBack,
      showSkip: widget.showSkip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('키/몸무게', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '키',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: widget.onHeightChanged,
                ),
              ),
              const SizedBox(width: 8),
              Text('cm', style: TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '몸무게(선택사항)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: widget.onWeightChanged,
                ),
              ),
              const SizedBox(width: 8),
              Text('kg', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '*몸무게를 입력하면 더 나은 코디를 추천받을 수 있어요. 해당 정보는 비공개로 유지돼요.',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
