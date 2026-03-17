import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_stylist_intro_screen.dart';
import 'preferred_style_screen.dart';
import 'body_type_screen.dart';
import 'clothing_size_screen.dart';
import 'preferred_brands_screen.dart';
import 'price_range_screen.dart';
import 'color_tone_screen.dart';
import 'complete_screen.dart';
import 'birthday_screen.dart';
import 'entry_screen.dart';
import 'gender_screen.dart';
import 'hair_color_screen.dart';
import 'height_weight_screen.dart';
import 'name_screen.dart';
import 'nickname_screen.dart';
import 'onboarding_data.dart';
import 'signup_screen.dart';
import 'step_screen.dart';
import 'style_screen.dart';
import 'terms_modal.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

const _kOnboardingCompleteKey = 'onboarding_complete';
const _kOnboardingDataKey = 'onboarding_data';

Future<bool> isOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingCompleteKey) ?? false;
}

Future<void> setOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingCompleteKey, true);
}

/// 온보딩 상태 초기화 (개발/테스트용)
Future<void> clearOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kOnboardingCompleteKey);
  await prefs.remove(_kOnboardingDataKey);
}

Future<void> saveOnboardingData(OnboardingData data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kOnboardingDataKey, jsonEncode(data.toJson()));
}

Future<OnboardingData> loadOnboardingData() async {
  final prefs = await SharedPreferences.getInstance();
  final s = prefs.getString(_kOnboardingDataKey);
  if (s == null) return OnboardingData();
  try {
    return OnboardingData.fromJson(jsonDecode(s) as Map<String, dynamic>?);
  } catch (_) {
    return OnboardingData();
  }
}

class OnboardingFlow extends StatefulWidget {
  final void Function({bool showAiStylistModal}) onComplete;

  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

enum _Phase {
  entry,
  login,
  welcome,
  signup,
  terms,
  nickname,
  name,
  gender,
  birthday,
  heightWeight,
  aiStylistIntro,
  preferredStyle,
  style,
  clothingSize,
  priceRange,
  preferredBrands,
  colorTone,
  hairColor,
  bodyType,
  aiStylistModal,
  complete,
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _data = OnboardingData();
  _Phase _phase = _Phase.entry;
  _Phase? _phaseBeforeGender;

  void _goTo(_Phase p) {
    if (p == _Phase.gender) _phaseBeforeGender = _phase;
    setState(() => _phase = p);
  }

  Future<void> _finishOnboarding({bool showAiStylistModal = false}) async {
    await saveOnboardingData(_data);
    await setOnboardingComplete();
    widget.onComplete(showAiStylistModal: showAiStylistModal);
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _Phase.entry:
        return OnboardingEntryScreen(
          onStart: () => _goTo(_Phase.welcome),
          onLogin: () => _goTo(_Phase.login),
        );
      case _Phase.login:
        return OnboardingLoginScreen(
          onLogin: () => _finishOnboarding(showAiStylistModal: false),
          onClose: () => _goTo(_Phase.entry),
        );
      case _Phase.welcome:
        return OnboardingWelcomeScreen(
          onNext: () => _goTo(_Phase.name),
          onSkip: () => _finishOnboarding(showAiStylistModal: false),
          onBack: () => _goTo(_Phase.entry),
        );
      case _Phase.signup:
        return OnboardingSignupScreen(
          onKakao: () => _showTermsAndProceed(),
          onGoogle: () => _showTermsAndProceed(),
          onOther: () => _goTo(_Phase.nickname),
          onLogin: () => _goTo(_Phase.login),
          onBrowse: () => _goTo(_Phase.welcome),
          onClose: () => _goTo(_Phase.entry),
        );
      case _Phase.terms:
        return const SizedBox.shrink();
      case _Phase.nickname:
        return OnboardingNicknameScreen(
          initialNickname: _data.nickname,
          onNicknameChanged: (v) => _data.nickname = v,
          onReferralCodeChanged: (_) {},
          onStart: () => _goTo(_Phase.gender),
          onBack: () => _goTo(_Phase.signup),
        );
      case _Phase.name:
        return OnboardingNameScreen(
          initialName: _data.nickname,
          onNameChanged: (v) => setState(() => _data.nickname = v),
          onNext: () => _goTo(_Phase.gender),
          onSkip: () => _goTo(_Phase.gender),
          onBack: () => _goTo(_Phase.welcome),
          showSkip: false,
        );
      case _Phase.gender:
        return OnboardingGenderScreen(
          selected: _data.gender,
          onSelect: (v) => setState(() => _data.gender = v),
          onNext: () => _goTo(_Phase.birthday),
          onSkip: () => _goTo(_Phase.birthday),
          onBack: () => _goTo(_Phase.name),
          showSkip: false,
        );
      case _Phase.birthday:
        return OnboardingBirthdayScreen(
          initialBirthday: _data.birthday,
          onBirthdayChanged: (v) => setState(() => _data.birthday = v),
          onNext: () => _goTo(_Phase.heightWeight),
          onSkip: () => _goTo(_Phase.heightWeight),
          onBack: () => _goTo(_Phase.gender),
          showSkip: false,
        );
      case _Phase.heightWeight:
        return OnboardingHeightWeightScreen(
          heightCm: _data.heightCm,
          weightKg: _data.weightKg,
          onHeightChanged: (v) => setState(() => _data.heightCm = v),
          onWeightChanged: (v) => setState(() => _data.weightKg = v),
          onNext: () => _goTo(_Phase.aiStylistIntro),
          onSkip: () => _goTo(_Phase.aiStylistIntro),
          onBack: () => _goTo(_Phase.birthday),
          showSkip: false,
        );
      case _Phase.aiStylistIntro:
        return OnboardingAiStylistIntroScreen(
          nickname: _data.nickname,
          onContinue: () => _goTo(_Phase.preferredStyle),
          onBack: () => _goTo(_Phase.heightWeight),
        );
      case _Phase.preferredStyle:
        return OnboardingPreferredStyleScreen(
          selected: _data.preferredStyle,
          onSelect: (v) => setState(() => _data.preferredStyle = v),
          onNext: () => _goTo(_Phase.style),
          onSkip: () => _goTo(_Phase.style),
          onBack: () => _goTo(_Phase.aiStylistIntro),
        );
      case _Phase.style:
        return OnboardingStyleScreen(
          selected: _data.styles,
          onToggle: (v) {
            setState(() {
              if (_data.styles.contains(v)) {
                _data.styles.remove(v);
              } else {
                _data.styles.add(v);
              }
            });
          },
          onNext: () => _goTo(_Phase.colorTone),
          onSkip: () => _goTo(_Phase.colorTone),
          onBack: () => _goTo(_Phase.preferredStyle),
        );
      case _Phase.colorTone:
        return OnboardingColorToneScreen(
          selected: _data.colorTone,
          onSelect: (v) => setState(() => _data.colorTone = v),
          onNext: () => _goTo(_Phase.hairColor),
          onSkip: () => _goTo(_Phase.hairColor),
          onBack: () => _goTo(_Phase.style),
        );
      case _Phase.hairColor:
        return OnboardingHairColorScreen(
          selected: _data.hairColor,
          onSelect: (v) => setState(() => _data.hairColor = v),
          onNext: () => _goTo(_Phase.bodyType),
          onSkip: () => _goTo(_Phase.bodyType),
          onBack: () => _goTo(_Phase.colorTone),
        );
      case _Phase.clothingSize:
        return OnboardingClothingSizeScreen(
          topSize: _data.topSize,
          bottomSize: _data.bottomSize,
          shoeSize: _data.shoeSize,
          onTopSizeChanged: (v) => setState(() => _data.topSize = v),
          onBottomSizeChanged: (v) => setState(() => _data.bottomSize = v),
          onShoeSizeChanged: (v) => setState(() => _data.shoeSize = v),
          onNext: () => _goTo(_Phase.priceRange),
          onSkip: () => _goTo(_Phase.priceRange),
          onBack: () => _goTo(_Phase.bodyType),
        );
      case _Phase.priceRange:
        return OnboardingPriceRangeScreen(
          selected: _data.priceRange,
          onSelect: (v) => setState(() => _data.priceRange = v),
          onNext: () => _goTo(_Phase.preferredBrands),
          onSkip: () => _goTo(_Phase.preferredBrands),
          onBack: () => _goTo(_Phase.clothingSize),
        );
      case _Phase.preferredBrands:
        return OnboardingPreferredBrandsScreen(
          selected: _data.preferredBrands,
          onToggle: (v) {
            setState(() {
              if (_data.preferredBrands.contains(v)) {
                _data.preferredBrands.remove(v);
              } else {
                _data.preferredBrands.add(v);
              }
            });
          },
          onNext: () => _goTo(_Phase.complete),
          onSkip: () => _goTo(_Phase.complete),
          onBack: () => _goTo(_Phase.priceRange),
        );
      case _Phase.bodyType:
        return OnboardingBodyTypeScreen(
          selected: _data.bodyType,
          onSelect: (v) => setState(() => _data.bodyType = v),
          onNext: () => _goTo(_Phase.clothingSize),
          onSkip: () => _goTo(_Phase.clothingSize),
          onBack: () => _goTo(_Phase.hairColor),
        );
      case _Phase.aiStylistModal:
        return const SizedBox.shrink();
      case _Phase.complete:
        return OnboardingCompleteScreen(
          onStart: () => _finishOnboarding(showAiStylistModal: true),
        );
    }
  }

  void _showTermsAndProceed() async {
    final agreed = await TermsModal.show(context);
    if (agreed == true && mounted) {
      _goTo(_Phase.nickname);
    }
  }
}
