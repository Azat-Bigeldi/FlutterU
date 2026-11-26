import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../screens/cart_screen.dart';
import '../theme.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Корзина',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      icon: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) => previous.count != current.count,
        builder: (context, state) => Badge(
          isLabelVisible: state.count > 0,
          label: Text('${state.count}'),
          backgroundColor: FlipColors.red,
          child: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
    );
  }
}
