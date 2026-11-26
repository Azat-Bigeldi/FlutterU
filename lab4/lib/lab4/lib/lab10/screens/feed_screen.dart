import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../theme.dart';
import '../widgets/cart_badge.dart';
import '../widgets/error_view.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  final ProductService? service;

  const FeedScreen({super.key, this.service});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final ProductService _service = widget.service ?? ProductService();

  List<Product> _products = [];
  ApiException? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    if (widget.service == null) _service.dispose();
    super.dispose();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final products = await _service.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _error = null;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _isLoading = false;
      });
    }
  }

  void _openDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            if (!_isLoading && _error == null)
              Text(
                '${_products.length} товаров',
                style: const TextStyle(fontSize: 12, color: FlipColors.grey),
              ),
          ],
        ),
        actions: const [CartBadge(), SizedBox(width: 4)],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = _error;
    if (error != null) {
      return ErrorView(
        title: error.title,
        message: error.message,
        onRetry: _load,
      );
    }

    return RefreshIndicator(
      color: FlipColors.blue,
      onRefresh: () => _load(showSpinner: false),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _products.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 0.5, indent: 92),
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductListTile(
            product: product,
            onTap: () => _openDetail(product),
          );
        },
      ),
    );
  }
}
