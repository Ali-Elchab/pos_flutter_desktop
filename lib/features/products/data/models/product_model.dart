import 'package:pos_flutter_desktop/core/constants/api_constants.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.barcode,
    this.category,
    this.imageUrl,
    this.stockQuantity = 0,
  });

  final String id;
  final String name;
  final double price;
  final String? barcode;
  final String? category;
  final String? imageUrl;
  final int stockQuantity;

  bool get isOutOfStock => stockQuantity <= 0;

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    String serverBaseUrl = ApiConstants.serverBaseUrl,
  }) {
    return ProductModel(
      id: (json['id'] ?? json['productId'] ?? json['sku']).toString(),
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      price: _readDouble(
        json['price'] ?? json['unitPrice'] ?? json['sellingPrice'],
      ),
      barcode: (json['barcode'] ?? json['sku'])?.toString(),
      category: (json['category'] ?? json['categoryName'])?.toString(),
      imageUrl: ApiConstants.resolveServerUrl(
        (json['imageUrl'] ?? json['imageURL'] ?? json['image'])?.toString(),
        serverBaseUrl: serverBaseUrl,
      ),
      stockQuantity: _readInt(json['stockQuantity'] ?? json['stock']),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _readInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
