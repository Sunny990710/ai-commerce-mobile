import 'package:flutter/material.dart';

/// 내 옷장 아이템 상세 화면
/// 계절, TPO, 카테고리, 색상, 브랜드, 가격, 소재, 사이즈等信息 표시
class ClosetItemDetailScreen extends StatefulWidget {
  final String brand;
  final String date;
  final String imageUrl;

  const ClosetItemDetailScreen({
    super.key,
    required this.brand,
    required this.date,
    required this.imageUrl,
  });

  @override
  State<ClosetItemDetailScreen> createState() => _ClosetItemDetailScreenState();
}

class _ClosetItemDetailScreenState extends State<ClosetItemDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedSeasonIndex = 2; // 기본: 가을
  int _selectedTpoIndex = 0; // 기본: 데일리
  bool _showSeasonChips = false;
  bool _showTpoChips = false;

  static const _seasons = ['봄', '여름', '가을', '겨울'];
  static const _tpoOptions = ['데일리', '직장', '학교', '데이트', '여행', '운동'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('내 옷 상세', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.shopping_bag_outlined, color: Colors.grey[700]), onPressed: () {}),
          IconButton(icon: Icon(Icons.bookmark_border, color: Colors.grey[700]), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert, color: Colors.grey[700]), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(),
                _buildActionButtons(),
                _buildTabBar(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildInfoContent(),
                  ),
                  _buildCoordiContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 240,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: Icon(Icons.checkroom, size: 64, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('편집'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[800],
                side: BorderSide(color: Colors.grey[400]!),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('AI로 바로입기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.black87,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: '정보'),
          Tab(text: '코디'),
        ],
      ),
    );
  }

  Widget _buildInfoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSeasonRow(),
        _buildTpoRow(),
        _buildInfoRow('카테고리', '상의 > 니트'),
        _buildColorRow(),
        _buildInfoRow('브랜드', widget.brand),
        _buildInfoRow('구매가격', '₩0'),
        _buildInfoRow('소재', '울 80%, 아크릴 20%'),
        _buildInfoRow('사이즈', 'M'),
        const SizedBox(height: 20),
        _buildPurchaseSection(),
        const SizedBox(height: 20),
        _buildMemoSection(),
      ],
    );
  }

  Widget _buildSeasonRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 80, child: Text('계절', style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _seasons[_selectedSeasonIndex],
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _showSeasonChips = !_showSeasonChips),
                      child: Icon(
                        _showSeasonChips ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showSeasonChips) ...[
          const SizedBox(height: 8),
          _buildChipRow(
            options: _seasons,
            selectedIndex: _selectedSeasonIndex,
            onSelect: (i) => setState(() {
              _selectedSeasonIndex = i;
              _showSeasonChips = false;
            }),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildTpoRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 80, child: Text('TPO', style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _tpoOptions[_selectedTpoIndex],
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _showTpoChips = !_showTpoChips),
                      child: Icon(
                        _showTpoChips ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showTpoChips) ...[
          const SizedBox(height: 8),
          _buildChipRow(
            options: _tpoOptions,
            selectedIndex: _selectedTpoIndex,
            onSelect: (i) => setState(() {
              _selectedTpoIndex = i;
              _showTpoChips = false;
            }),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildChipRow({
    required List<String> options,
    required int selectedIndex,
    required void Function(int) onSelect,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(options.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? Colors.grey[800]! : Colors.grey[400]!,
                width: 1,
              ),
            ),
            child: Text(
              options[i],
              style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : Colors.grey[600],
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[500]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 80, child: Text('색상', style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
          Expanded(
            child: Row(
              children: [
                Container(width: 24, height: 24, decoration: const BoxDecoration(color: Color(0xFF9E9E9E), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 24, height: 24, decoration: const BoxDecoration(color: Color(0xFF37474F), shape: BoxShape.circle)),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[500]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildPurchaseItem('구매가격', '₩0')),
              Expanded(child: _buildPurchaseItem('착용 횟수', '0')),
              Expanded(child: _buildPurchaseItem('지원담 비용', '₩0')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  static const _coordiImages = [
    'assets/images/outfit_flatlay.png',
    'assets/images/outfit_flatlay2.png',
    'assets/images/outfit_flatlay3.png',
  ];

  Widget _buildCoordiContent() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(16),
      childAspectRatio: 0.95,
      children: [
        ...List.generate(_coordiImages.length, (i) => _buildCoordiCard(_coordiImages[i])),
        _buildAddCoordiCard(),
      ],
    );
  }

  Widget _buildCoordiCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: Icon(Icons.checkroom, size: 48, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCoordiCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 36, color: Colors.grey[400]),
            const SizedBox(height: 6),
            Text(
              '코디 추가하기',
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('메모', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[500]),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('메모를 입력해보세요.', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ),
      ],
    );
  }

}
