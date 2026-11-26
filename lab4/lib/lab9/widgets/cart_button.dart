import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../theme.dart';

class CartButton extends StatelessWidget {
  final Product product;

  final bool compact;
  final double height;
  final String addLabel;
  final String inCartLabel;

  const CartButton({
    super.key,
    required this.product,
    this.compact = false,
    this.height = 34,
    this.addLabel = 'В корзину',
    this.inCartLabel = 'В корзине',
  });

  @override
  Widget build(BuildContext context) {
    final inCart = context.select<CartBloc, bool>(
      (bloc) => bloc.state.contains(product.id),
    );
    void onPressed() => context.read<CartBloc>().add(
      inCart ? RemoveProductEvent(product.id) : AddProductEvent(product),
    );

    if (compact) {
      return IconButton(
        tooltip: inCart ? 'Убрать из корзины' : 'В корзину',
        onPressed: onPressed,
        icon: Icon(
          inCart ? Icons.shopping_cart : Icons.add_shopping_cart,
          color: inCart ? FlipColors.blue : Colors.black54,
        ),
      );
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(height / 2),
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: inCart
          ? OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: FlipColors.blue,
                side: const BorderSide(color: FlipColors.blue),
                padding: EdgeInsets.zero,
                shape: shape,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.check, size: 18),
              label: Text(inCartLabel),
            )
          : FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: FlipColors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                shape: shape,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: Text(addLabel),
            ),
    );
  }
}
