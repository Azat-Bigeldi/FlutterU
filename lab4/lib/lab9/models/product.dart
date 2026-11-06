/// Модель товара. Весь объект целиком передаётся в DetailScreen.
/// `id` уникален — используется в ValueKey для Dismissible.
class Product {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final int price;
  final int oldPrice;
  final String category;
  final String details; // обложка, год, издательство
  final double rating; // LW8: звёздный рейтинг 0.0–5.0

  const Product({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.details,
    required this.rating,
  });

  int get discountPercent => ((oldPrice - price) * 100 / oldPrice).round();
}
