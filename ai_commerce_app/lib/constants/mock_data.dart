import '../models/product.dart';

final List<Product> mockProducts = [
  Product(id: '1', brand: 'Free People', name: 'Findings Slide Sandal', price: 198000, originalPrice: 248000, tag: '여름 추천', category: '신발', keywords: '샌들 슬라이드 여름 플로럴 캐주얼', image: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=800&q=80', stock: 5),
  Product(id: '2', brand: 'MIXXO', name: 'Gemstone Bracelet', price: 49000, originalPrice: 59000, tag: '강력 추천', category: '액세서리', keywords: '팔찌 주얼리 골드 실버', image: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=800&q=80', stock: 0),
  Product(id: '3', brand: 'Rag & Bone', name: 'Buttoned Denim Jeans - Women', price: 647000, originalPrice: 729000, tag: 'AI 추천 딜', category: '바지', keywords: '데님 진 와이드 하이웨스트', image: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=800&q=80', stock: 2),
  Product(id: '4', brand: 'Gap', name: 'Essential Cotton Tee', price: 39900, originalPrice: 49900, tag: '트렌딩', category: '상의', keywords: '티셔츠 면 기본 베이직', image: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?auto=format&fit=crop&w=800&q=80', stock: 12),
  Product(id: '5', brand: 'MIXXO', name: 'Silk Ruffle Blouse', price: 159000, originalPrice: 189000, tag: '베스트셀러', category: '상의', keywords: '블라우스 실크 러플 오피스', image: 'https://images.unsplash.com/photo-1564257631407-4deb1f99d992?auto=format&fit=crop&w=800&q=80', stock: 8),
  Product(id: '6', brand: 'SPAO', name: 'Relaxed Fit Hoodie', price: 45900, originalPrice: 59900, tag: '가성비', category: '상의', keywords: '후디 맨투맨 캐주얼', image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=800&q=80', stock: 15),
  Product(id: '7', brand: 'New Balance', name: 'Fresh Foam Running Shoes', price: 129000, originalPrice: 159000, tag: '인기', category: '신발', keywords: '운동화 러닝 스니커즈', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80', stock: 6),
  Product(id: '8', brand: 'WHO.A.U', name: 'Eco Cotton Cargo Pants', price: 79900, originalPrice: 99000, tag: '친환경', category: '바지', keywords: '카고팬츠 면 와이드', image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80', stock: 4),
  // 환절기 레이어드 추천용
  Product(id: '101', brand: '자라', name: '스트라이프 오버사이즈 티셔츠', price: 29900, originalPrice: 39000, tag: '환절기 추천', category: '상의', keywords: '스트라이프 티셔츠 오버사이즈 레이어드', image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=800&q=80', stock: 10),
  Product(id: '102', brand: '유니클로', name: '경량 패딩', price: 49900, originalPrice: 69000, tag: '베스트셀러', category: '아우터', keywords: '패딩 경량 환절기 레이어드', image: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?auto=format&fit=crop&w=800&q=80', stock: 15),
  Product(id: '103', brand: '스파오', name: '밴딩 와이드 팬츠', price: 39900, originalPrice: 49000, tag: '가성비', category: '바지', keywords: '밴딩 와이드팬츠 캐주얼 출근룩', image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80', stock: 8),
];

final List<String> quickChips = [
  '이번 주말 데이트룩 추천해 줘',
  '요즘 유행하는 와이드 팬츠 찾아줘',
  '하객룩으로 입을 원피스 보여줘',
  '출근룩 추천해 줘',
  '가성비 좋은 상의 찾아줘',
];
