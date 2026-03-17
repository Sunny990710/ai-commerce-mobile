import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingNameScreen extends StatefulWidget {
  final String? initialName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final bool showSkip;

  const OnboardingNameScreen({
    super.key,
    this.initialName,
    required this.onNameChanged,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    this.showSkip = true,
  });

  @override
  State<OnboardingNameScreen> createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
  late final _controller = TextEditingController(text: widget.initialName ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid {
    final len = _controller.text.trim().length;
    return len == 0 || (len >= 5 && len <= 15);
  }

  bool get _showError {
    final len = _controller.text.trim().length;
    return len > 0 && (len < 5 || len > 15);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '사용하실 이름을 알려주세요',
      progress: 0.05,
      nextEnabled: _isValid,
      showSkip: widget.showSkip,
      onNext: () {
        widget.onNameChanged(_controller.text.trim());
        widget.onNext();
      },
      onSkip: widget.onSkip,
      onBack: widget.onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '이름은 5~15자 내외로 작성해주세요',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_showError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '5~15자 내외로 작성해주세요',
                style: TextStyle(fontSize: 12, color: Colors.red[700]),
              ),
            ),
        ],
      ),
    );
  }
}
