import 'package:flutter/material.dart';

import '../constants/mock_data.dart';
import '../models/product.dart';
import 'onboarding/onboarding_data.dart';
import 'onboarding/onboarding_flow.dart';
import 'product_detail_screen.dart';
import 'my_style_profile_screen.dart';

/// 나와 비슷한 스타일러 페이지 - 체형/취향이 비슷한 사람들의 코디
class ExploreScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Set<String>? wishIds;
  final void Function(Product)? onToggleWish;

  const ExploreScreen({
    super.key,
    this.onBack,
    this.wishIds,
    this.onToggleWish,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  OnboardingData? _data;
  bool _loading = true;
  int _selectedTabIndex = 0;
  int _bodyTypeFilterIndex = 0;
  int? _pollVoteIndex;

  static const _topTabs = ['추천', '나와 비슷한', '팔로잉', '체형별', '키 155-160'];
  static const _bodyTypeFilters = ['내 체형 (S~M)', '155-160cm', '160~165cm', '165-170cm'];
  static const _bodyTypeStylists = [
    (name: '민지', likes: 238, color: 0xFFF5F0E8, imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'),
    (name: '서연', likes: 186, color: 0xFFE8EDF2, imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200'),
    (name: '하온', likes: 156, color: 0xFF4A5568, imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200'),
    (name: '유진', likes: 142, color: 0xFFE8DFD5, imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200'),
    (name: '소율', likes: 128, color: 0xFFB8D4CE, imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'),
    (name: '지우', likes: 119, color: 0xFFF2E5E5, imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200'),
  ];
  static const _pollLeftImage = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=600';
  static const _pollRightImage = 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=600';

  static const _stylists = [
    (name: '민지', height: '164cm', weight: '54kg', size: 'S', match: 97, outfits: 48, avatarPath: 'assets/images/stylist_avatar_1.png'),
    (name: '서연', height: '162cm', weight: '56kg', size: 'S', match: 94, outfits: 32, avatarPath: 'assets/images/stylist_avatar_2.png'),
    (name: '하은', height: '165cm', weight: '55kg', size: 'M', match: 92, outfits: 28, avatarPath: 'assets/images/stylist_avatar_3.png'),
  ];

  static const _outfitProducts = [
    ('SPAO', '린넨 오버핏 셔츠', 44900, 25),
    ('COS', '와이드 코튼 팬츠', 89000, null),
    ('자라', '베이직 가디건', 59000, 32),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await loadOnboardingData();
    if (mounted) setState(() {
      _data = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildTopTabs(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildStyleProfileCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _buildSimilarStylistsSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: _buildStylistOutfitDetailCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _buildBodyTypePopularSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _buildWorkOutfitPollSection(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('탐색', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
      centerTitle: true,
      elevation: 0,
      leading: widget.onBack != null
          ? IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20), onPressed: widget.onBack)
          : null,
    );
  }

  Widget _buildTopTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_topTabs.length, (i) {
            final selected = _selectedTabIndex == i;
            return Padding(
              padding: EdgeInsets.only(right: i < _topTabs.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.black87 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _topTabs[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStyleProfileCard() {
    final height = _data?.heightCm ?? '165';
    final weight = _data?.weightKg ?? '55';
    final styles = _data?.styles;
    final styleTags = styles?.where((s) => s.isNotEmpty).take(3).toList() ?? ['미니멀', '데일리룩', '비즈니스캐주얼'];
    final sizeLabel = '${_data?.topSize ?? 'S'}-${_data?.bottomSize ?? 'M'}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.9), size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '나의 스타일 프로필',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '비슷한 사람 2,847명이 활동 중',
                      style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyStyleProfileScreen()));
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('수정', style: TextStyle(fontSize: 13, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProfileTag('${height}cm'),
              _ProfileTag('${weight}kg'),
              _ProfileTag(sizeLabel),
              ...styleTags.map((s) => _ProfileTag(s)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarStylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '나와 비슷한 스타일러',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  '체형 · 취향이 비슷한 사람들의 코디',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text('전체보기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.purple[700])),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _stylists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final s = _stylists[i];
              return _StylistSummaryCard(
                name: s.name,
                height: s.height,
                weight: s.weight,
                match: s.match,
                outfits: s.outfits,
                avatarPath: s.avatarPath,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStylistOutfitDetailCard() {
    final s = _stylists[0];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Icon(Icons.person, size: 20, color: Colors.green[700]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Text(s.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 4),
                    Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${s.height} · ${s.weight} · ${s.size} · ${s.match}% 일치',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.more_horiz, color: Colors.grey[700]), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                'assets/images/stylist_outfit_sample.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF5F0E8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checkroom, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('오티핏', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('164 cm', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 12),
              Text('54 kg', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 12),
              Text('S 사이즈', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 12),
              Text('상의 M', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(width: 8),
              Text('착용', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite, size: 20, color: Colors.red[400]),
              const SizedBox(width: 4),
              Text('238', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('42', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              const SizedBox(width: 16),
              Icon(Icons.share_outlined, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('공유', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              const Spacer(),
              Icon(Icons.bookmark_border, size: 22, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '민지 봄 출근룩으로 딱이에요 🌷 린넨 셔츠 M 입었는데 지한테 모델핏으로 떨어져서 예뻐요. 하라는 S로!',
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _outfitProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final p = _outfitProducts[i];
                final product = mockProducts[i % mockProducts.length];
                return _OutfitProductCard(
                  brand: p.$1,
                  name: p.$2,
                  price: p.$3,
                  discount: p.$4,
                  imageUrl: product.image,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: product,
                          wishIds: widget.wishIds ?? {},
                          onToggleWish: widget.onToggleWish ?? (_) {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyTypePopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '체형별 인기 코디',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  '같은 체형이 가장 많이 저장한 코디',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text('전체보기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.purple[700])),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_bodyTypeFilters.length, (i) {
              final selected = _bodyTypeFilterIndex == i;
              return Padding(
                padding: EdgeInsets.only(right: i < _bodyTypeFilters.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _bodyTypeFilterIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.black87 : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _bodyTypeFilters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
          children: List.generate(_bodyTypeStylists.length, (i) {
            final s = _bodyTypeStylists[i];
            return Container(
              decoration: BoxDecoration(
                color: Color(s.color),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        s.imageUrl,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (_, __, ___) => Icon(Icons.person, size: 22, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 12, color: Colors.red[400]),
                      const SizedBox(width: 2),
                      Text('${s.likes}', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWorkOutfitPollSection() {
    final leftPercent = _pollVoteIndex == 0 ? 62 : (_pollVoteIndex == 1 ? 38 : 62);
    final rightPercent = _pollVoteIndex == 0 ? 38 : (_pollVoteIndex == 1 ? 62 : 38);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '이번 주 출근룩, 어떤 게 나을까?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                Icon(Icons.local_fire_department, size: 20, color: Colors.orange[600]),
                const SizedBox(width: 4),
                Text('진행 중', style: TextStyle(fontSize: 12, color: Colors.orange[600])),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _pollVoteIndex = 0),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Image.network(
                            _pollLeftImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF5F0E8)),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('$leftPercent%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                              ),
                            ),
                            child: const Text(
                              '린넨 셔츠+슬랙스',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('VS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _pollVoteIndex = 1),
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Image.network(
                            _pollRightImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF4A5568)),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('$rightPercent%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                              ),
                            ),
                            child: const Text(
                              '블레이저+데니',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                              child: const Icon(Icons.add, color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  final String label;

  const _ProfileTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }
}

class _StylistSummaryCard extends StatelessWidget {
  final String name;
  final String height;
  final String weight;
  final int match;
  final int outfits;
  final String avatarPath;

  const _StylistSummaryCard({
    required this.name,
    required this.height,
    required this.weight,
    required this.match,
    required this.outfits,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: match / 100,
                  strokeWidth: 2.5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(match >= 95 ? Colors.green : Colors.orange),
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    avatarPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person, size: 22, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$match% 일치', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 1),
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('$height $weight', style: TextStyle(fontSize: 10, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('코디 ${outfits}개', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('팔로우', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[700])),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitProductCard extends StatelessWidget {
  final String brand;
  final String name;
  final int price;
  final int? discount;
  final String imageUrl;
  final VoidCallback onTap;

  const _OutfitProductCard({
    required this.brand,
    required this.name,
    required this.price,
    this.discount,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(brand, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[700])),
            Text(name, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Row(
              children: [
                if (discount != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text('$discount%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red[400])),
                  ),
                Text('₩${_formatPrice(price)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int p) {
    final s = p.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
