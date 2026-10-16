import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

/// Вкладка 1 — лента товаров.
class FeedScreen extends StatelessWidget {
  final FavoritesStore favorites;

  const FeedScreen({super.key, required this.favorites});

  void _openDetail(BuildContext context, Product product) {
    // Navigator.push + передача всего объекта Product в конструктор
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(product: product, favorites: favorites),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Поиск
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: FlipColors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('over 1,000,000 products',
                          style: TextStyle(
                              color: FlipColors.grey, fontSize: 16)),
                    ),
                    Icon(Icons.photo_camera_outlined, color: FlipColors.grey),
                  ],
                ),
              ),
            ),
          ),
          // Баннер
          SliverToBoxAdapter(
            child: Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Книги на английском',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('скидки до −20%',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('Вы смотрели',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
          ),
          // Сетка товаров
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ProductCard(
                  product: products[i],
                  favorites: favorites,
                  onTap: () => _openDetail(context, products[i]),
                ),
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
