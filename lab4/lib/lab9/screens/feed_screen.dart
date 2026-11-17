import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_badge.dart';
import '../widgets/delete_background.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

enum ViewMode { list, grid }

class FeedScreen extends StatefulWidget {
  final FavoritesStore favorites;

  const FeedScreen({super.key, required this.favorites});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  ViewMode _viewMode = ViewMode.list;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailScreen(product: product, favorites: widget.favorites),
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _viewMode = _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
    });
  }

  Future<void> _onRefresh() async {
    try {
      final products = await fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    setState(() {
      _products.removeAt(index);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
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

  void _undoRemove(Product product, int index) {
    if (!mounted) return;
    setState(() {
      _products.insert(index.clamp(0, _products.length), product);
    });
  }

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
            if (!_isLoading && _errorMessage == null)
              Text(
                '${_products.length} товаров',
                style: const TextStyle(fontSize: 12, color: FlipColors.grey),
              ),
          ],
        ),
        actions: [
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
          const CartBadge(),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          const _SearchBar(),
          Expanded(child: _buildBody(isList)),
        ],
      ),
    );
  }

  Widget _buildBody(bool isList) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      color: FlipColors.blue,
      onRefresh: _onRefresh,
      child: _products.isEmpty
          ? _buildEmptyState()
          : (isList ? _buildListView() : _buildGridView()),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 96, color: FlipColors.grey),
            const SizedBox(height: 16),
            const Text('Не удалось загрузить товары',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: FlipColors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlipColors.yellow,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      key: const PageStorageKey('feed_list'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.5, indent: 84),
      itemBuilder: (context, index) {
        final product = _products[index];
        return Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
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
        childAspectRatio: 0.6,
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

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          child: EmptyState(onReset: _loadProducts),
        ),
      ),
    );
  }
}

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
