class Product {
  final String id;
  final String brand;
  final String name;
  final int price;
  final int originalPrice;
  final String tag;
  final String category;
  final String keywords;
  final String image;
  final int stock;
  final List<ProductColor>? colors;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    this.originalPrice = 0,
    this.tag = '',
    this.category = '',
    this.keywords = '',
    required this.image,
    this.stock = 5,
    this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] is int) ? json['price'] : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      originalPrice: (json['originalPrice'] is int) ? json['originalPrice'] : int.tryParse(json['originalPrice']?.toString() ?? '0') ?? 0,
      tag: json['tag']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      keywords: json['keywords']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      stock: (json['stock'] is int) ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '5') ?? 5,
      colors: null,
    );
  }

  String get formattedPrice {
    var s = price.toString();
    var buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₩${buf.toString()}';
  }
  String get formattedOriginalPrice {
    if (originalPrice <= 0) return '';
    var s = originalPrice.toString();
    var buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₩${buf.toString()}';
  }
  int get discountPercent => originalPrice > 0 && originalPrice > price ? ((1 - price / originalPrice) * 100).round() : 0;
}

class ProductColor {
  final String name;
  final String hex;
  final int stock;
  final String image;
  ProductColor({required this.name, required this.hex, this.stock = 5, required this.image});
}
