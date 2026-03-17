import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingPreferredBrandsScreen extends StatefulWidget {
  final List<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingPreferredBrandsScreen({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const options = [
    'SPAO', 'NIKE', 'MUSINSA', 'ZARA', 'ADIDAS', 'POLO',
    'H&M', 'UNIQLO', '디스커버리', '노스페이스', '뉴발란스',
    '빅스타', '에잇세컨즈', '탑텐', '코듀로이', '지고트', '폴로랄프로렌',
  ];

  static const minSelection = 5;

  @override
  State<OnboardingPreferredBrandsScreen> createState() => _OnboardingPreferredBrandsScreenState();
}

class _OnboardingPreferredBrandsScreenState extends State<OnboardingPreferredBrandsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _canProceed => widget.selected.length >= OnboardingPreferredBrandsScreen.minSelection;

  List<String> get _filteredOptions {
    if (_searchQuery.trim().isEmpty) return OnboardingPreferredBrandsScreen.options;
    final q = _searchQuery.trim().toLowerCase();
    return OnboardingPreferredBrandsScreen.options
        .where((opt) => opt.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: '자주 구매하는 브랜드가 있나요?',
      progress: 0.52,
      spacingAfterTitle: 6,
      horizontalPadding: 32,
      nextEnabled: _canProceed,
      onNext: widget.onNext,
      onSkip: widget.onSkip,
      onBack: widget.onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최소 5개 이상 선택',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: '브랜드 검색',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, size: 22, color: Colors.grey.shade600),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!_canProceed && widget.selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${OnboardingPreferredBrandsScreen.minSelection - widget.selected.length}개 더 선택해주세요',
                style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filteredOptions.map((opt) {
                  final isSelected = widget.selected.contains(opt);
                  return GestureDetector(
                    onTap: () => widget.onToggle(opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
