part of 'cart_cubit.dart';

enum PaymentMethod {
  cash('Cash'),
  card('Card'),
  mobile('Mobile');

  const PaymentMethod(this.label);

  final String label;
}

class CartState extends Equatable {
  const CartState({
    this.items = const [],
    this.paymentMethod = PaymentMethod.cash,
  });

  static const double taxRate = 0.11;

  final List<CartItemModel> items;
  final PaymentMethod paymentMethod;

  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.total);

  double get tax => _roundMoney(subtotal * taxRate);

  double get total => _roundMoney(subtotal + tax);

  CartState copyWith({
    List<CartItemModel>? items,
    PaymentMethod? paymentMethod,
  }) {
    return CartState(
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [items, paymentMethod];

  double _roundMoney(double value) => (value * 100).roundToDouble() / 100;
}
