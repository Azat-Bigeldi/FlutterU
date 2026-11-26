import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../theme.dart';
import '../widgets/product_image.dart';
import 'detail_screen.dart';

/// Вкладка 2 — избранное.
class FavoritesScreen extends StatelessWidget {
  final FavoritesStore favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Favorites',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                Text('All products', style: TextStyle(color: FlipColors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: favorites,
              builder: (context, _) {
                final items = favorites.items;
                if (items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        "You haven't added anything to favorites yet.\n"
                        'Add products to favorites using ❤️',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: FlipColors.grey, fontSize: 16),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailScreen(product: p, favorites: favorites),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 100,
                                child: ProductImage(url: p.imageUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Text(p.author,
                                        style: const TextStyle(
                                            color: FlipColors.grey)),
                                    const SizedBox(height: 6),
                                    Text(formatPrice(p.price),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: FlipColors.red),
                                onPressed: () => favorites.toggle(p),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
