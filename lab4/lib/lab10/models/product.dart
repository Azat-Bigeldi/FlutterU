class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    final ratingMap = rating is Map<String, dynamic> ? rating : const <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Без названия',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingMap['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }

  List<String> get gallery => [imageUrl, imageUrl, imageUrl];

  String get deepLink => 'narxoz://store/product/$id';
}
