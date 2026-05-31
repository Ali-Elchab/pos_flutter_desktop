class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.sku,
    this.category,
  });

  final String id;
  final String name;
  final double price;
  final String? sku;
  final String? category;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? json['productId'] ?? json['sku']).toString(),
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      price: _readDouble(
        json['price'] ?? json['unitPrice'] ?? json['sellingPrice'],
      ),
      sku: json['sku']?.toString(),
      category: (json['category'] ?? json['categoryName'])?.toString(),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
