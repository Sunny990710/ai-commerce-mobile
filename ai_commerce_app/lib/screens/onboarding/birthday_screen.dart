import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'step_screen.dart';

class OnboardingBirthdayScreen extends StatefulWidget {
  final DateTime? initialBirthday;
  final ValueChanged<DateTime?> onBirthdayChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final bool showSkip;

  const OnboardingBirthdayScreen({
    super.key,
    this.initialBirthday,
    required this.onBirthdayChanged,
    required this.onNext,
    required this.onSkip,
    this.onBack,
    this.showSkip = true,
  });

  @override
  State<OnboardingBirthdayScreen> createState() => _OnboardingBirthdayScreenState();
}

class _OnboardingBirthdayScreenState extends State<OnboardingBirthdayScreen> {
  DateTime _selectedDate = DateTime(2000, 6, 15);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final fallback = DateTime(now.year - 20, 6, 15);
    _selectedDate = widget.initialBirthday ?? fallback;
  }

  void _onDateChanged(DateTime date) {
    if (!mounted) return;
    setState(() => _selectedDate = date);
    widget.onBirthdayChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return OnboardingStepScreen(
      title: '생일이 언제인가요?',
      progress: 0.2,
      onNext: () {
        widget.onBirthdayChanged(_selectedDate);
        widget.onNext();
      },
      onSkip: () {
        widget.onBirthdayChanged(_selectedDate);
        widget.onSkip();
      },
      onBack: widget.onBack,
      showSkip: widget.showSkip,
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRect(
          child: SizedBox(
            height: 165,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Brightness.light,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    fontSize: 20,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: now,
                minimumDate: DateTime(1900, 1, 1),
                onDateTimeChanged: _onDateChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
