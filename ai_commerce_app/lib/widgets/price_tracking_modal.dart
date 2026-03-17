import 'package:flutter/material.dart';
import '../models/product.dart';

void showPriceTrackingModal(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _PriceTrackingModalContent(product: product),
  );
}

String _formatPrice(int p) {
  final s = p.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '₩$buf';
}

class _PriceTrackingModalContent extends StatefulWidget {
  final Product product;

  const _PriceTrackingModalContent({required this.product});

  @override
  State<_PriceTrackingModalContent> createState() => _PriceTrackingModalContentState();
}

class _PriceTrackingModalContentState extends State<_PriceTrackingModalContent> {
  int _selectedTab = 1;
  double _targetPriceRatio = 0.6;
  bool _autonomousPurchase = true;

  static const _priceData = [45200, 44100, 42800, 41900, 40500, 39100, 38500, 37905];
  static const _rankData = [8, 7, 5, 4, 3, 3, 2, 2];
  static const _weeks = ['1/1주', '1/3주', '2/1주', '2/3주', '3/1주', '3/3주', '4/1주', '4/3주'];

  int get _currentPrice => widget.product.price;
  int get _minPrice => (_currentPrice * 0.5).round();
  int get _maxPrice => _currentPrice;
  int get _targetPrice => (_minPrice + (_maxPrice - _minPrice) * _targetPriceRatio).round();
  int get _aiRecommendedPrice => (_currentPrice * 0.75).round();
  int get _lowestPrice8w => _priceData.reduce((a, b) => a < b ? a : b);
  int get _priceChangePercent => ((1 - _currentPrice / _priceData.first) * 100).round();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(ctx: context),
                  const SizedBox(height: 20),
                  _buildProductInfo(ctx: context),
                  const SizedBox(height: 20),
                  _buildTabs(ctx: context),
                  const SizedBox(height: 16),
                  if (_selectedTab == 0) ...[
                    _buildPriceTrackingContent(ctx: context),
                  ] else ...[
                    _buildMetricsCards(ctx: context),
                    const SizedBox(height: 16),
                    _buildChartSection(ctx: context),
                    const SizedBox(height: 16),
                    _buildAiInsight(ctx: context),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
            child: _buildButtons(ctx: context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required BuildContext ctx}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.insights, size: 22, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price Intelligence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text('AI 기반 시장 모니터링 & 트렌드 분석', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(ctx),
          style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
        ),
      ],
    );
  }

  Widget _buildProductInfo({required BuildContext ctx}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.product.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: Colors.grey[200], child: Icon(Icons.image, color: Colors.grey[400])),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.brand.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(widget.product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('현재 시장가: ${_formatPrice(_currentPrice)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs({required BuildContext ctx}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabChip(0, Icons.notifications_none, '가격 추적'),
          const SizedBox(width: 4),
          _buildTabChip(1, Icons.show_chart, '추이 분석'),
        ],
      ),
    );
  }

  Widget _buildTabChip(int index, IconData icon, String label) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.grey[800] : Colors.grey[500]),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal, color: selected ? Colors.black87 : Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTrackingContent({required BuildContext ctx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('목표 구매가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            GestureDetector(
              onTap: () => setState(() => _targetPriceRatio = (_aiRecommendedPrice - _minPrice) / (_maxPrice - _minPrice)),
              child: Text('AI 추천: ${_formatPrice(_aiRecommendedPrice)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue[700])),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(ctx).copyWith(
            activeTrackColor: Colors.grey[800],
            inactiveTrackColor: Colors.grey[200],
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.1),
            trackHeight: 6,
          ),
          child: Slider(
            value: _targetPriceRatio,
            onChanged: (v) => setState(() => _targetPriceRatio = v),
            min: 0,
            max: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatPrice(_minPrice), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(_formatPrice(_targetPrice), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(_formatPrice(_maxPrice), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('자율 구매', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('목표가 도달 시 AI가 자동 구매를 실행합니다.', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _autonomousPurchase,
                  onChanged: (v) => setState(() => _autonomousPurchase = v),
                  activeTrackColor: Colors.blue[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCards({required BuildContext ctx}) {
    return Row(
      children: [
        Expanded(child: _MetricCard(label: '8주 최저가', value: _formatPrice(_lowestPrice8w), color: Colors.green[600]!)),
        const SizedBox(width: 10),
        Expanded(child: _MetricCard(label: '가격 변동', value: '▼ $_priceChangePercent%', color: Colors.green[600]!)),
        const SizedBox(width: 10),
        Expanded(child: _MetricCard(label: '현재 순위', value: '${_rankData.last}위', color: Colors.blue[700]!)),
      ],
    );
  }

  Widget _buildChartSection({required BuildContext ctx}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('추이 분석', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['45k', '41k', '38k'].map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(t, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  )).toList(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: CustomPaint(
                    painter: _PriceChartPainter(
                      priceData: _priceData,
                      rankData: _rankData,
                      priceColor: Colors.blue[400]!,
                      rankColor: Colors.green[400]!,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['1위', '4위', '8위'].map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(t, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  )).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: List.generate(_weeks.length, (i) => Expanded(
                child: Text(_weeks[i], style: TextStyle(color: Colors.grey[400], fontSize: 9), textAlign: TextAlign.center),
              )),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.blue[400], shape: BoxShape.circle)), const SizedBox(width: 6), Text('판매가격', style: TextStyle(color: Colors.grey[400], fontSize: 12))]),
              const SizedBox(width: 20),
              Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green[400], shape: BoxShape.circle)), const SizedBox(width: 6), Text('순위', style: TextStyle(color: Colors.grey[400], fontSize: 12))]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsight({required BuildContext ctx}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: Colors.blue[700]),
              const SizedBox(width: 6),
              Text('AI 가격 인사이트', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700])),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '최근 8주간 가격이 $_priceChangePercent% 하락했어요. 현재 ${_formatPrice(_currentPrice)}로 최근 최저가에 근접한 시점입니다. 지금이 구매 적기일 수 있어요!',
            style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons({required BuildContext ctx}) {
    final isPriceTracking = _selectedTab == 0;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[800],
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('취소', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(isPriceTracking ? '가격 모니터링이 활성화되었어요' : '가격 알림이 설정되었어요'),
              ));
            },
            icon: const Icon(Icons.notifications_none, size: 20),
            label: Text(isPriceTracking ? '가격 알림' : '가격 알림 설정', style: const TextStyle(fontWeight: FontWeight.bold)),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _PriceChartPainter extends CustomPainter {
  final List<int> priceData;
  final List<int> rankData;
  final Color priceColor;
  final Color rankColor;

  _PriceChartPainter({required this.priceData, required this.rankData, required this.priceColor, required this.rankColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (priceData.isEmpty) return;
    final priceMin = 35000.0;
    final priceMax = 47000.0;
    final rankMin = 1.0;
    final rankMax = 8.0;

    final pad = 4.0;
    final w = size.width - pad * 2;
    final h = size.height - pad * 2;

    double priceToY(double v) => pad + h - ((v - priceMin) / (priceMax - priceMin) * h);
    double rankToY(double v) => pad + h - ((v - rankMin) / (rankMax - rankMin) * h);
    double xAt(int i) => pad + (i / (priceData.length - 1).clamp(1, 10)) * w;

    final pricePath = Path();
    for (var i = 0; i < priceData.length; i++) {
      final pt = Offset(xAt(i), priceToY(priceData[i].toDouble()));
      if (i == 0) pricePath.moveTo(pt.dx, pt.dy);
      else pricePath.lineTo(pt.dx, pt.dy);
    }

    final rankPath = Path();
    for (var i = 0; i < rankData.length; i++) {
      final pt = Offset(xAt(i), rankToY(rankData[i].toDouble()));
      if (i == 0) rankPath.moveTo(pt.dx, pt.dy);
      else rankPath.lineTo(pt.dx, pt.dy);
    }

    canvas.drawPath(rankPath, Paint()..color = rankColor..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    canvas.drawPath(pricePath, Paint()..color = priceColor..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);

    for (var i = 0; i < priceData.length; i++) {
      canvas.drawCircle(Offset(xAt(i), priceToY(priceData[i].toDouble())), 4, Paint()..color = priceColor);
    }
    for (var i = 0; i < rankData.length; i++) {
      canvas.drawCircle(Offset(xAt(i), rankToY(rankData[i].toDouble())), 4, Paint()..color = rankColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
