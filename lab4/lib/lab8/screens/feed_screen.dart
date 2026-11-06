import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/delete_background.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_tile.dart';
import 'detail_screen.dart';

enum ViewMode { list, grid }

/// Вкладка 1 — каталог Flip.
/// LW8: List/Grid toggle, pull-to-refresh, swipe-to-delete + UNDO, empty state.
class FeedScreen extends StatefulWidget {
  final FavoritesStore favorites;

  const FeedScreen({super.key, required this.favorites});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  /// Единый источник данных для обоих режимов.
  List<Product> _products = seedProducts();

  ViewMode _viewMode = ViewMode.grid;

  // Действия

  void _openDetail(Product product) {
    // Navigator.push + передача всего объекта Product (из LW7)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DetailScreen(product: product, favorites: widget.favorites),
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _viewMode = _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
    });
  }

  /// Pull-to-Refresh: "сеть" 1.5 с → новый товар в index 0.
  Future<void> _onRefresh() async {
    final newProduct = await fetchNewProduct();

    // За 1.5 с экран мог быть закрыт — тогда setState нельзя.
    if (!mounted) return;

    setState(() {
      _products.insert(0, newProduct);
    });
  }

  /// Swipe-to-Delete: удаляем, запоминаем индекс, показываем UNDO.
  void _removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    setState(() {
      _products.removeAt(index);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar(); // не копим очередь снекбаров
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Text('«${product.title}» удалён'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: FlipColors.yellow,
          onPressed: () => _undoRemove(product, index),
        ),
      ),
    );
  }

  /// Возвращаем товар на ИСХОДНЫЙ индекс.
  /// clamp — если список успел стать короче.
  void _undoRemove(Product product, int index) {
    if (!mounted) return;
    setState(() {
      _products.insert(index.clamp(0, _products.length), product);
    });
  }

  void _resetCatalog() {
    setState(() {
      _products = seedProducts();
    });
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final isList = _viewMode == ViewMode.list;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Flip',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: FlipColors.blue,
              ),
            ),
            Text(
              '${_products.length} товаров',
              style: const TextStyle(fontSize: 12, color: FlipColors.grey),
            ),
          ],
        ),
        actions: [
          // Toggle List ⇄ Grid
          IconButton(
            tooltip: isList ? 'Сетка' : 'Список',
            onPressed: _toggleView,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isList ? Icons.grid_view_rounded : Icons.view_list_rounded,
                key: ValueKey(_viewMode),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const _SearchBar(),
          Expanded(
            child: RefreshIndicator(
              color: FlipColors.blue,
              onRefresh: _onRefresh,
              // Без AnimatedSwitcher: он держал бы старый ListView с уже
              // "dismissed" Dismissible → assertion error.
              child: _products.isEmpty
                  ? _buildEmptyState()
                  : (isList ? _buildListView() : _buildGridView()),
            ),
          ),
        ],
      ),
    );
  }

  /// Режим 1 — ленивый список с тонкими разделителями.
  Widget _buildListView() {
    return ListView.separated(
      key: const PageStorageKey('feed_list'),
      // RefreshIndicator работает, даже если элементы не заполняют экран.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.5, indent: 80),
      itemBuilder: (context, index) {
        final product = _products[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart, // только справа налево
          background: const DeleteBackground(),
          onDismissed: (_) => _removeProduct(product),
          child: ProductListTile(
            product: product,
            onTap: () => _openDetail(product),
          ),
        );
      },
    );
  }

  /// Режим 2 — ленивая сетка в 2 колонки.
  Widget _buildGridView() {
    return GridView.builder(
      key: const PageStorageKey('feed_grid'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72, // ширина / высота
      ),
      itemBuilder: (context, index) {
        final product = _products[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          background: DeleteBackground(borderRadius: BorderRadius.circular(14)),
          onDismissed: (_) => _removeProduct(product),
          child: ProductCard(
            product: product,
            favorites: widget.favorites,
            onTap: () => _openDetail(product),
          ),
        );
      },
    );
  }

  /// Empty state тоже скроллится — pull-to-refresh работает и на нём.
  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: EmptyState(onReset: _resetCatalog),
        ),
      ),
    );
  }
}

/// Поисковая строка из LW7 (декоративная).
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
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
              child: Text(
                'over 1,000,000 products',
                style: TextStyle(color: FlipColors.grey, fontSize: 16),
              ),
            ),
            Icon(Icons.photo_camera_outlined, color: FlipColors.grey),
          ],
        ),
      ),
    );
  }
}
