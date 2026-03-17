import 'package:flutter/material.dart';

class OnboardingNicknameScreen extends StatefulWidget {
  final String? initialNickname;
  final ValueChanged<String> onNicknameChanged;
  final ValueChanged<String?> onReferralCodeChanged;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const OnboardingNicknameScreen({
    super.key,
    this.initialNickname,
    required this.onNicknameChanged,
    required this.onReferralCodeChanged,
    required this.onStart,
    required this.onBack,
  });

  static final _nicknameRegex = RegExp(r'^[a-zA-Z0-9_.]{5,15}$');

  @override
  State<OnboardingNicknameScreen> createState() => _OnboardingNicknameScreenState();
}

class _OnboardingNicknameScreenState extends State<OnboardingNicknameScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _referralController;
  bool _referralExpanded = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.initialNickname ?? '');
    _referralController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  bool get _isValid => OnboardingNicknameScreen._nicknameRegex.hasMatch(_nicknameController.text.trim());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '닉네임을 입력해주세요',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                    onPressed: () => setState(() => _nicknameController.clear()),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Text(
                '닉네임은 5~15자의 영문 대소문자, 숫자, 밑줄, 마침표만 사용 가능해요.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () => setState(() => _referralExpanded = !_referralExpanded),
                child: Row(
                  children: [
                    const Text('추천 코드', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 8),
                    Icon(_referralExpanded ? Icons.expand_less : Icons.expand_more, size: 24, color: Colors.grey),
                  ],
                ),
              ),
              if (_referralExpanded) ...[
                const SizedBox(height: 8),
                Text(
                  '코드를 입력하세요. 가입 후에는 추천 코드를 입력할 수 없어요.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _referralController,
                  decoration: InputDecoration(
                    hintText: '추천 코드',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (v) => widget.onReferralCodeChanged(v.isEmpty ? null : v),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isValid ? () {
                    widget.onNicknameChanged(_nicknameController.text.trim());
                    widget.onStart();
                  } : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _isValid ? Colors.black87 : Colors.grey,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('시작하기'),
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
