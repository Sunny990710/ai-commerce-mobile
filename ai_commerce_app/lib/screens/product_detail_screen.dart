import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/price_tracking_modal.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;

  const ProductDetailScreen({super.key, required this.product, required this.wishIds, required this.onToggleWish});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _images => [widget.product.image, widget.product.image, widget.product.image];

  List<({String name, bool isLowest, int original, int current, String shipping, String benefits, String action})> _getChannelPrices() {
    final base = widget.product.originalPrice > 0 ? widget.product.originalPrice : widget.product.price;
    final b = (base / 1000).round() * 1000;
    String fmt(int n) {
      final s = n.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '₩$buf';
    }
    return [
      (name: 'ABLY', isLowest: true, original: b + 2000, current: (b * 0.74).round(), shipping: 'Free', benefits: '혜택 적용 2개 - ${fmt((b * 0.068).round())}', action: '사이트 방문'),
      (name: 'E-Land Mall', isLowest: false, original: b + 1000, current: (b * 0.76).round(), shipping: 'Free', benefits: '혜택 적용 2개 - ${fmt((b * 0.069).round())}', action: '구매하기'),
      (name: 'Musinsa', isLowest: false, original: b + 3000, current: (b * 0.78).round(), shipping: 'Free', benefits: '혜택 적용 3개 - ${fmt((b * 0.04).round())}', action: '사이트 방문'),
      (name: 'Zigzag', isLowest: false, original: b + 2500, current: (b * 0.79).round(), shipping: '₩2,500', benefits: '혜택 적용 2개 - ${fmt((b * 0.02).round())}', action: '사이트 방문'),
    ];
  }

  String _formatPrice(int p) {
    final s = p.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₩${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWished = widget.wishIds.contains(product.id);
    final channels = _getChannelPrices();
    final lowestPrice = channels.map((c) => c.current).reduce((a, b) => a < b ? a : b);
    final discountPercent = product.originalPrice > 0 ? ((1 - lowestPrice / product.originalPrice) * 100).round() : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.share, color: Colors.black87), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _currentImageIndex = i),
                      itemCount: _images.length,
                      itemBuilder: (_, i) => Container(
                        color: Colors.grey[100],
                        child: Image.network(
                          _images[i],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 64)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_currentImageIndex > 0) {
                            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_currentImageIndex < _images.length - 1) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_right, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_images.length, (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentImageIndex == i ? 8 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == i ? Colors.grey[800] : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(product.brand.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('색상: 블루 플로럴', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      const SizedBox(width: 16),
                      Text('재고: ${product.stock > 0 ? "있음" : "없음"}', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ColorSwatch(color: Colors.blue, isSelected: true),
                      const SizedBox(width: 8),
                      _ColorSwatch(color: Colors.pink, isSelected: false),
                      const SizedBox(width: 8),
                      _ColorSwatch(color: Colors.black, isSelected: false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.brand.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                            const SizedBox(height: 4),
                            Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => widget.onToggleWish(product),
                        icon: Icon(isWished ? Icons.bookmark : Icons.bookmark_border, size: 20, color: Colors.grey[700]),
                        label: Text('저장', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildTabChip(0, Icons.lightbulb_outline, 'AI 추천', Colors.amber),
                        const SizedBox(width: 4),
                        _buildTabChip(1, Icons.star_outline, '리뷰', Colors.amber),
                        const SizedBox(width: 4),
                        _buildTabChip(2, Icons.warning_amber_outlined, '체크', Colors.orange),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.topCenter,
                    child: _buildTabContent(product),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('정상가 ${_formatPrice(product.originalPrice > 0 ? product.originalPrice : product.price)}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      TextButton.icon(
                        onPressed: () => showPriceTrackingModal(context, product),
                        icon: Icon(Icons.show_chart, size: 16, color: Colors.grey[700]),
                        label: Text('가격 추적', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('$discountPercent%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                            const SizedBox(width: 8),
                            Text(_formatPrice(lowestPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('나의 예상 구매가', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                        const SizedBox(height: 8),
                        Text('각 플랫폼의 혜택을 적용하여 실제 구매가를 비교해 보세요.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...channels.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ChannelPriceCard(
                      name: c.name,
                      isLowest: c.isLowest,
                      originalPrice: c.original,
                      currentPrice: c.current,
                      shipping: c.shipping,
                      benefits: c.benefits,
                      action: c.action,
                      formatPrice: _formatPrice,
                    ),
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ABLY 최저가 확인 기능은 준비 중이에요'))),
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text('ABLY 최저가 확인'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('제품 정보', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Icon(Icons.chevron_right, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(int index, IconData icon, String label, Color iconColor) {
    final selected = _tabController.index == index;
    final reviewActive = index == 1 && selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                reviewActive ? Icons.local_fire_department : icon,
                size: 18,
                color: selected ? (reviewActive ? Colors.red[400] : iconColor) : Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal, color: selected ? Colors.black87 : Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(Product product) {
    switch (_tabController.index) {
      case 0:
        return _buildAiRecommendTab(product);
      case 1:
        return _buildReviewTab();
      case 2:
        return _buildCheckTab();
      default:
        return _buildAiRecommendTab(product);
    }
  }

  Widget _buildAiRecommendTab(Product product) {
    const summary = '편안한 착용감과 세련된 디자인. 단독 착용은 물론 레이어링에도 활용도 높음.';
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          summary,
          style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _buildReviewTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text('4.7', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Text('(134개 리뷰 기반)', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('AI 요약', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple[700])),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ReviewSummaryRow(label: '사이즈', text: '평소 사이즈로 주문하면 적당하며, 오버핏을 원하면 한 사이즈 업을 추천해요.'),
            _ReviewSummaryRow(label: '소재', text: '부드럽고 통기성이 좋아 여름에도 쾌적하게 입을 수 있어요.'),
            _ReviewSummaryRow(label: '핏', text: '어깨 라인이 깔끔하게 떨어지며, 체형 커버에 좋다는 평이 많아요.'),
            _ReviewSummaryRow(label: '세탁', text: '세탁기 사용 가능하며, 줄어들거나 늘어남이 적다는 후기에요.'),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('도움이 되었나요?', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(width: 8),
                Icon(Icons.thumb_up_outlined, size: 20, color: Colors.orange[300]),
                const SizedBox(width: 12),
                Icon(Icons.thumb_down_outlined, size: 20, color: Colors.orange[300]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckRow(icon: Icons.warning_amber_outlined, text: '모니터에 따라 실제 색상 차이 가능'),
            _CheckRow(icon: Icons.warning_amber_outlined, text: '드라이클리닝 권장'),
            _CheckRow(icon: Icons.info_outline, text: '사이즈 교환은 수령 후 7일 이내 가능'),
          ],
        ),
      ),
    );
  }
}


class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorSwatch({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? Colors.black87 : Colors.grey[300]!, width: isSelected ? 2 : 1),
      ),
    );
  }
}

class _ReviewSummaryRow extends StatelessWidget {
  final String label;
  final String text;

  const _ReviewSummaryRow({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CheckRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isWarning = icon == Icons.warning_amber || icon == Icons.warning_amber_outlined;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isWarning ? Colors.amber[700] : Colors.blue[700]),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4))),
        ],
      ),
    );
  }
}

class _ChannelPriceCard extends StatelessWidget {
  final String name;
  final bool isLowest;
  final int originalPrice;
  final int currentPrice;
  final String shipping;
  final String benefits;
  final String action;
  final String Function(int) formatPrice;

  const _ChannelPriceCard({
    required this.name,
    required this.isLowest,
    required this.originalPrice,
    required this.currentPrice,
    required this.shipping,
    required this.benefits,
    required this.action,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isLowest ? Colors.green : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              if (isLowest) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                  child: const Text('최저가', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (originalPrice > currentPrice)
                Text(formatPrice(originalPrice), style: TextStyle(fontSize: 12, color: Colors.grey[500], decoration: TextDecoration.lineThrough)),
              if (originalPrice > currentPrice) const SizedBox(width: 8),
              Text(formatPrice(currentPrice), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text('배송: $shipping', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text(benefits, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(action, style: TextStyle(fontSize: 13, color: Colors.blue[700])),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.blue[700]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
