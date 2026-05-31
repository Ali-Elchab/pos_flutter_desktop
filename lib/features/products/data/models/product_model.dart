import 'package:pos_flutter_desktop/core/constants/api_constants.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.sku,
    this.category,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final String? sku;
  final String? category;
  final String? imageUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? json['productId'] ?? json['sku']).toString(),
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      price: _readDouble(
        json['price'] ?? json['unitPrice'] ?? json['sellingPrice'],
      ),
      sku: json['sku']?.toString(),
      category: (json['category'] ?? json['categoryName'])?.toString(),
      imageUrl: ApiConstants.resolveServerUrl(
        (json['imageUrl'] ?? json['imageURL'] ?? json['image'])?.toString(),
      ),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
