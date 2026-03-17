import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/mock_data.dart';
import '../models/product.dart';

class ApiService {
  // Android 에뮬레이터에서 호스트 접근: 10.0.2.2
  // 실제 기기에서는 본인 PC IP로 변경 필요
  static const String baseUrl = 'http://10.0.2.2:7860';

  static Future<AiSearchResponse> aiSearch(String input) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/ai-search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input': input}),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final ids = (data['matchedIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final message = data['message']?.toString() ?? '추천 결과를 찾았어요!';
        final products = ids.map((id) => mockProducts.where((p) => p.id == id).firstOrNull).whereType<Product>().toList();
        if (products.isEmpty) {
          return _fallbackSearch(input);
        }
        return AiSearchResponse(message: message, products: products);
      }
    } catch (_) {}
    return _fallbackSearch(input);
  }

  static AiSearchResponse _fallbackSearch(String input) {
    final q = input.toLowerCase();
    var scored = <(Product, int)>[];
    for (final p in mockProducts) {
      var score = 0;
      final searchable = '${p.name} ${p.brand} ${p.keywords} ${p.category}'.toLowerCase();
      for (final w in q.split(RegExp(r'\s+'))) {
        if (w.length > 1 && searchable.contains(w)) score += 2;
      }
      scored.add((p, score));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    final top = scored.where((s) => s.$2 > 0).take(3).map((s) => s.$1).toList();
    final products = top.isNotEmpty ? top : mockProducts.take(3).toList();
    final names = products.map((p) => '${p.brand} ${p.name}').join(', ');
    return AiSearchResponse(
      message: top.isNotEmpty ? '"$input"에 어울리는 아이템을 찾았어요! $names을(를) 추천드립니다.' : '인기 아이템을 모아봤어요! $names',
      products: products,
    );
  }
}

class AiSearchResponse {
  final String message;
  final List<Product> products;
  AiSearchResponse({required this.message, required this.products});
}
