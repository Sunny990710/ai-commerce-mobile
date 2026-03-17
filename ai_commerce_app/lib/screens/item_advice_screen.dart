import 'package:flutter/material.dart';

import '../models/product.dart';

/// 아이템 분석 및 조언 화면
class ItemAdviceScreen extends StatelessWidget {
  final String itemImageUrl;
  final String itemBrand;
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final VoidCallback onClose;

  const ItemAdviceScreen({
    super.key,
    required this.itemImageUrl,
    required this.itemBrand,
    required this.wishIds,
    required this.onToggleWish,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildItemImage(),
                    const SizedBox(height: 20),
                    _buildOverallRatingText(),
                    const SizedBox(height: 16),
                    _buildMainSummary(),
                    const SizedBox(height: 16),
                    _buildRatingCards(),
                    const SizedBox(height: 16),
                    _buildAiMessageBubble(),
                    const SizedBox(height: 16),
                    _buildAnalysisCard(),
                    const SizedBox(height: 12),
                    _buildStyleMatchCard(),
                    const SizedBox(height: 12),
                    _buildCoordiSuggestionsCard(),
                    const SizedBox(height: 12),
                    _buildNotesCard(),
                    const SizedBox(height: 12),
                    _buildClosetMatchCard(),
                    const SizedBox(height: 12),
                    _buildBodyTypeCard(),
                    const SizedBox(height: 20),
                    _buildBottomButtons(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          itemImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.checkroom, size: 64, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallRatingText() {
    return Text(
      '전체 평점: 8.5/10',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildMainSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '활용도 높은 클래식 아이템',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            '페어 아일 니트는 시즌 활용도와 스타일 범용성이 좋아요. 단품으로도 존재감 있는 아이템이에요.',
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCards() {
    final ratings = [
      ('디자인', 9.0, Icons.palette_outlined, const Color(0xFFE91E63), const Color(0xFF4CAF50)),
      ('활용도', 8.5, Icons.refresh, const Color(0xFF2196F3), const Color(0xFF7C4DFF)),
      ('스타일 매치', 8.0, Icons.checkroom_outlined, const Color(0xFF2196F3), const Color(0xFF7C4DFF)),
      ('가성비', 8.5, Icons.savings_outlined, const Color(0xFFFFC107), const Color(0xFF4CAF50)),
    ];
    return Row(
      children: ratings.asMap().entries.map((e) {
        final i = e.key;
        final (label, value, icon, iconColor, lineColor) = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
            child: _buildRatingCard(label, value, icon, iconColor, lineColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingCard(String label, double value, IconData icon, Color iconColor, Color lineColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: lineColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiMessageBubble() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1BEE7).withOpacity(0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.add, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'bonobinu님, 이 아이템 평가해봤어요! 단품 이미지라 전체 코디 점수는 어렵지만, 아이템 자체의 매력과 옷장 조화 가능성을 분석했어요.',
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return _buildSectionCard(
      icon: Icons.checkroom,
      iconColor: const Color(0xFF4CAF50),
      title: '아이템 분석',
      badge: '매력적',
      badgeColor: const Color(0xFF7C4DFF),
      content: '페어 아일(Fair Isle) 패턴의 니트는 겨울/초봄에 딱 맞는 클래식한 아이템이에요. 전통적이면서도 캐주얼한 느낌이 잘 살아있어요.',
      tags: [
        _Tag('✓ 클래식 패턴', true),
        _Tag('✓ 시즌 활용도 높음', true),
        _Tag('가을/겨울 한정', false),
      ],
    );
  }

  Widget _buildStyleMatchCard() {
    return _buildSectionCard(
      icon: Icons.favorite_outline,
      iconColor: const Color(0xFFE91E63),
      title: '내 스타일과 궁합',
      badge: '잘 맞음',
      badgeColor: const Color(0xFF4CAF50),
      content: '선호하는 캐주얼/스트릿웨어 스타일에 자연스럽게 어울려요. 데일리룩이나 주말 외출에 특히 활용하기 좋아요.',
      tags: [
        _Tag('✓ 캐주얼 스타일 적합', true),
        _Tag('✓ 스트릿 믹스 가능', true),
        _Tag('비즈니스룩에는 부적합', false, isNegative: true),
      ],
    );
  }

  Widget _buildCoordiSuggestionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 22, color: Colors.amber[700]),
              const SizedBox(width: 8),
              const Text(
                '추천 코디 조합',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Spacer(),
              Text(
                '3가지 제안',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 16),
          _buildCoordiPoint('캐주얼 데일리 – 데님 + 스니커즈로 편안하게'),
          _buildCoordiPoint('레이어드룩 – 셔츠 위에 니트, 코트 안에 레이어드'),
          _buildCoordiPoint('스트릿 믹스 – 카고 팬츠 + 부츠로 하드하게'),
        ],
      ),
    );
  }

  Widget _buildCoordiPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star, size: 16, color: Colors.red[400]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 22, color: Colors.amber[700]),
              const SizedBox(width: 8),
              const Text(
                '참고할 점',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Spacer(),
              Text('체크', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '패턴이 있는 아이템이라 하의는 단색으로 매칭하는 게 좋아요. 너무 다른 패턴과 겹치면 산만해질 수 있어요.',
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPillTag('패턴 충돌 주의', false, Colors.orange),
              _buildPillTag('하의 단색 추천', false, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClosetMatchCard() {
    final closetItems = [
      ('치노 팬츠', '잘 어울림', 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=200', true),
      ('페니 로퍼', '잘 어울림', 'https://images.unsplash.com/photo-1614252369475-531eba835eb1?w=200', true),
      ('바이커 자켓', '잘 어울림', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=200', true),
      ('와이드 데님', '보통', 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=200', false),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checkroom_outlined, size: 22, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Text(
                '내 옷장과 얼마나 핏할까',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Spacer(),
              Text(
                '78%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: closetItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final (name, eval, imageUrl, hasCheck) = closetItems[i];
                return SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.checkroom, color: Colors.grey[500], size: 24),
                              ),
                            ),
                          ),
                          if (hasCheck)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.check_circle, size: 20, color: Colors.green[600]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        eval,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 18, color: Colors.amber[700]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '치노 팬츠와 가장 잘 어울려요',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('코디 해보기', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyTypeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, size: 22, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Text(
                '비슷한 체형이 이 아이템을 입으면',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(3, (_) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600], size: 24),
                ),
              )),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '+24',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '나와 비슷한 체형(164~167cm, S~M)의 28명이 이 아이템을 코디에 활용했어요. 대부분 상의 M 사이즈를 선택했어요.',
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('구매 기능은 준비 중이에요')));
            },
            icon: const Icon(Icons.shopping_bag_outlined, size: 22),
            label: const Text('이 아이템 구매하기 - ₩89,000'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 20),
                label: const Text('위시리스트'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey[400]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('다른 아이템 평가'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey[400]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String badge,
    required Color badgeColor,
    required String content,
    required List<_Tag> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Spacer(),
              Text(
                badge,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: badgeColor),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20, color: badgeColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((t) => _buildTagPill(t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagPill(_Tag tag) {
    if (tag.isPositive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag.label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.green[800]),
        ),
      );
    }
    if (tag.isNegative) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag.label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red[700]),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag.label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildPillTag(String text, bool isGreen, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color.withOpacity(0.9)),
      ),
    );
  }
}

class _Tag {
  final String label;
  final bool isPositive;
  final bool isNegative;

  _Tag(this.label, this.isPositive, {this.isNegative = false});
}

