import 'package:pos_flutter_desktop/features/cart/data/models/cart_item_model.dart';

class CreateSaleRequest {
  const CreateSaleRequest({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
  });

  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toReceiptJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'paymentMethod': paymentMethod,
    };
  }
}
