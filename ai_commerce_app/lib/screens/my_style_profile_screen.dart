import 'package:flutter/material.dart';

import 'onboarding/onboarding_data.dart';
import 'onboarding/onboarding_flow.dart';

/// 내 스타일 프로필 화면
/// 온보딩에서 설정한 개인화 정보를 한 페이지에 표시
class MyStyleProfileScreen extends StatefulWidget {
  const MyStyleProfileScreen({super.key});

  @override
  State<MyStyleProfileScreen> createState() => _MyStyleProfileScreenState();
}

class _MyStyleProfileScreenState extends State<MyStyleProfileScreen> {
  OnboardingData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadOnboardingData();
    if (mounted) {
      setState(() {
        _data = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('내 정보', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '프로필을 설정하면 AI 스타일리스트가\n더 정확하게 추천해드려요',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  _buildSection('성별', [_data?.gender].whereType<String>().toList()),
                  _buildSection('스타일', _data?.styles ?? []),
                  _buildSection('주요 스타일', [_data?.preferredStyle].whereType<String>().toList()),
                  _buildSection('색상 프로파일', [_data?.colorTone].whereType<String>().toList()),
                  _buildBodySection(),
                  _buildSection('선호 브랜드', _data?.preferredBrands ?? []),
                  _buildSection('옷 구매 예산', [_data?.priceRange].whereType<String>().toList()),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, List<String> values) {
    return _ProfileSection(
      title: title,
      values: values,
      onTap: () {},
    );
  }

  Widget _buildBodySection() {
    final parts = <String>[];
    if (_data?.bodyType != null) parts.add(_data!.bodyType!);
    if (_data?.heightCm != null && _data?.weightKg != null) {
      parts.add('${_data!.heightCm}cm ${_data!.weightKg}kg');
    } else if (_data?.heightCm != null) {
      parts.add('${_data!.heightCm}cm');
    } else if (_data?.weightKg != null) {
      parts.add('${_data!.weightKg}kg');
    }
    return _ProfileSection(
      title: '체형 정보',
      values: parts,
      onTap: () {},
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<String> values;
  final VoidCallback onTap;

  const _ProfileSection({
    required this.title,
    required this.values,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: values.isEmpty
                          ? [
                              Text(
                                '설정 전',
                                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                              ),
                            ]
                          : values.map((v) => _Tag(text: v)).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 22, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey[800], fontWeight: FontWeight.w500),
      ),
    );
  }
}
