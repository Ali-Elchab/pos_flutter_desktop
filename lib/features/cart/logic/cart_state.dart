part of 'cart_cubit.dart';

class CartState extends Equatable {
  const CartState({this.items = const []});

  static const double taxRate = 0.08;

  final List<CartItemModel> items;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.total);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
