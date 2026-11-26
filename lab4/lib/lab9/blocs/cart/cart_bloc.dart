import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddProductEvent>(_onAddProduct);
    on<RemoveProductEvent>(_onRemoveProduct);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddProduct(AddProductEvent event, Emitter<CartState> emit) {
    // Каждый товар лежит в корзине в одном экземпляре.
    if (state.contains(event.product.id)) return;
    emit(CartState(items: [...state.items, event.product]));
  }

  void _onRemoveProduct(RemoveProductEvent event, Emitter<CartState> emit) {
    emit(
      CartState(
        items: state.items.where((p) => p.id != event.productId).toList(),
      ),
    );
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(CartState());
  }
}
