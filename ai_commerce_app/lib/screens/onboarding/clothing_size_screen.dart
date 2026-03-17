import 'package:flutter/material.dart';

class OnboardingClothingSizeScreen extends StatefulWidget {
  final String? topSize;
  final String? bottomSize;
  final String? shoeSize;
  final ValueChanged<String> onTopSizeChanged;
  final ValueChanged<String> onBottomSizeChanged;
  final ValueChanged<String> onShoeSizeChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const OnboardingClothingSizeScreen({
    super.key,
    required this.topSize,
    required this.bottomSize,
    required this.shoeSize,
    required this.onTopSizeChanged,
    required this.onBottomSizeChanged,
    required this.onShoeSizeChanged,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  static const topOptions = ['2XS', 'XS', 'S', 'M', 'L', 'XL', '2XL'];
  static const bottomOptions = ['2XS', 'XS', 'S', 'M', 'L', 'XL', '2XL'];
  static const shoeOptions = ['210', '220', '230', '240', '250', '260', '270', '280', '290', '300'];

  @override
  State<OnboardingClothingSizeScreen> createState() => _OnboardingClothingSizeScreenState();
}

class _OnboardingClothingSizeScreenState extends State<OnboardingClothingSizeScreen> {
  @override
  Widget build(BuildContext context) {
    return _ClothingSizeLayout(
      title: '주로 입는 사이즈를 선택해주세요',
      nextButtonLabel: '다음',
      progress: 0.4,
      onNext: widget.onNext,
      onSkip: widget.onSkip,
      onBack: widget.onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SizeSection(
            label: '상의',
            options: OnboardingClothingSizeScreen.topOptions,
            selected: widget.topSize,
            onSelected: widget.onTopSizeChanged,
          ),
          const SizedBox(height: 24),
          _SizeSection(
            label: '하의',
            options: OnboardingClothingSizeScreen.bottomOptions,
            selected: widget.bottomSize,
            onSelected: widget.onBottomSizeChanged,
          ),
          const SizedBox(height: 24),
          _SizeSection(
            label: '신발',
            options: OnboardingClothingSizeScreen.shoeOptions,
            selected: widget.shoeSize,
            onSelected: widget.onShoeSizeChanged,
          ),
        ],
      ),
    );
  }
}

class _ClothingSizeLayout extends StatelessWidget {
  final String title;
  final String nextButtonLabel;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final Widget child;
  final double progress;

  const _ClothingSizeLayout({
    required this.title,
    required this.nextButtonLabel,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    required this.child,
    this.progress = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: progress > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.black87),
                ),
              )
            : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(onPressed: onSkip, child: const Text('건너뛰기', style: TextStyle(color: Colors.black54))),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
              const SizedBox(height: 24),
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
                  child: Text(nextButtonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeSection extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _SizeSection({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  static const _selectedColor = Color(0xFF1976D2);  // blue.shade700
  static const _selectedBgColor = Color(0xFFE3F2FD); // blue.shade50

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onSelected(opt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _selectedBgColor : Colors.white,
                  border: Border.all(
                    color: isSelected ? _selectedColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? _selectedColor : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
