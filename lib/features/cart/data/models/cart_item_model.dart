import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';

class CartItemModel {
  const CartItemModel({required this.product, required this.quantity});

  final ProductModel product;
  final int quantity;

  double get total => product.price * quantity;

  Map<String, dynamic> toReceiptJson() {
    return {
      'productId': product.id,
      'name': product.name,
      'barcode': product.barcode,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'unitPrice': product.price,
      'quantity': quantity,
      'lineTotal': total,
    };
  }

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(product: product, quantity: quantity ?? this.quantity);
  }
}
