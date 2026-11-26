/// Модель товара. Весь объект целиком передаётся в DetailScreen.
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
  });

  int get discountPercent => ((oldPrice - price) * 100 / oldPrice).round();
}
