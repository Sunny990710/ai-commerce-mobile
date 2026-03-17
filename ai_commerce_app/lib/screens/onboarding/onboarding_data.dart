class OnboardingData {
  String? gender;
  DateTime? birthday;
  String? heightCm;
  String? weightKg;
  String? preferredStyle;
  String? topSize;
  String? bottomSize;
  String? shoeSize;
  String? priceRange;
  List<String> preferredBrands = [];
  String? bodyType;
  String? hairColor;
  String? colorTone;
  List<String> styles = [];
  String? nickname;
  bool agreedToTerms = false;

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'birthday': birthday?.toIso8601String(),
        'heightCm': heightCm,
        'weightKg': weightKg,
        'preferredStyle': preferredStyle,
        'topSize': topSize,
        'bottomSize': bottomSize,
        'shoeSize': shoeSize,
        'priceRange': priceRange,
        'preferredBrands': preferredBrands,
        'bodyType': bodyType,
        'hairColor': hairColor,
        'colorTone': colorTone,
        'styles': styles,
        'nickname': nickname,
      };

  static OnboardingData fromJson(Map<String, dynamic>? json) {
    final d = OnboardingData();
    if (json == null) return d;
    d.gender = json['gender'] as String?;
    d.birthday = json['birthday'] != null ? DateTime.tryParse(json['birthday'] as String) : null;
    d.heightCm = json['heightCm'] as String?;
    d.weightKg = json['weightKg'] as String?;
    d.preferredStyle = json['preferredStyle'] as String?;
    d.topSize = json['topSize'] as String?;
    d.bottomSize = json['bottomSize'] as String?;
    d.shoeSize = json['shoeSize'] as String?;
    d.priceRange = json['priceRange'] as String?;
    d.preferredBrands = (json['preferredBrands'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
    d.bodyType = json['bodyType'] as String?;
    d.hairColor = json['hairColor'] as String?;
    d.colorTone = json['colorTone'] as String?;
    d.styles = (json['styles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
    d.nickname = json['nickname'] as String?;
    return d;
  }

  void reset() {
    gender = null;
    birthday = null;
    heightCm = null;
    weightKg = null;
    preferredStyle = null;
    topSize = null;
    bottomSize = null;
    shoeSize = null;
    priceRange = null;
    preferredBrands = [];
    bodyType = null;
    hairColor = null;
    colorTone = null;
    styles = [];
    nickname = null;
    agreedToTerms = false;
  }
}
