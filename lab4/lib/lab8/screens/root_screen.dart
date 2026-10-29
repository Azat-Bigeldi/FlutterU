import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../theme.dart';
import 'favorites_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';

/// Корневой экран с BottomNavigationBar (3 вкладки).
/// IndexedStack сохраняет состояние каждой вкладки (скролл и т.д.).
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  final FavoritesStore _favorites = FavoritesStore();

  @override
  void dispose() {
    _favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          FeedScreen(favorites: _favorites),
          FavoritesScreen(favorites: _favorites),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _favorites,
        builder: (context, _) => BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.white,
          selectedItemColor: FlipColors.blue,
          unselectedItemColor: FlipColors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: _favorites.items.isNotEmpty,
                label: Text('${_favorites.items.length}'),
                backgroundColor: FlipColors.red,
                child: const Icon(Icons.favorite_border),
              ),
              activeIcon: const Icon(Icons.favorite),
              label: 'Favorites',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
