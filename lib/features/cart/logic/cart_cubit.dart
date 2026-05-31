import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/features/cart/data/models/cart_item_model.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    emit(state.copyWith(paymentMethod: paymentMethod));
  }

  void addProduct(ProductModel product) {
    final items = List<CartItemModel>.from(state.items);
    final existingIndex = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      if (product.isOutOfStock) return;
      items.add(CartItemModel(product: product, quantity: 1));
    } else {
      final existing = items[existingIndex];
      if (existing.quantity >= product.stockQuantity) return;
      items[existingIndex] = existing.copyWith(quantity: existing.quantity + 1);
    }

    emit(state.copyWith(items: items));
  }

  void increaseItem(CartItemModel item) {
    addProduct(item.product);
  }

  void decreaseItem(CartItemModel item) {
    final items = List<CartItemModel>.from(state.items);
    final existingIndex = items.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );

    if (existingIndex == -1) return;

    final existing = items[existingIndex];
    if (existing.quantity <= 1) {
      items.removeAt(existingIndex);
    } else {
      items[existingIndex] = existing.copyWith(quantity: existing.quantity - 1);
    }

    emit(state.copyWith(items: items));
  }

  void clear() {
    emit(CartState(paymentMethod: state.paymentMethod));
  }
}
