import 'package:pos_flutter_desktop/core/constants/api_constants.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/create_sale_request.dart';

class SaleModel {
  const SaleModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    this.receiptNumber,
    this.createdAt,
  });

  final String id;
  final String? receiptNumber;
  final DateTime? createdAt;
  final List<SaleReceiptItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return SaleModel(
      id: (json['id'] ?? json['saleId'] ?? '').toString(),
      receiptNumber: (json['receiptNumber'] ?? json['receiptNo'])?.toString(),
      createdAt: DateTime.tryParse(
        (json['createdAt'] ?? json['date'] ?? '').toString(),
      ),
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(SaleReceiptItem.fromJson)
                .toList()
          : const [],
      subtotal: _readDouble(json['subtotal']),
      tax: _readDouble(json['tax']),
      total: _readDouble(json['total']),
      paymentMethod: (json['paymentMethod'] ?? '').toString(),
    );
  }

  factory SaleModel.fromRequest(CreateSaleRequest request) {
    return SaleModel(
      id: '',
      items: request.items
          .map(
            (item) => SaleReceiptItem(
              productId: item.product.id,
              name: item.product.name,
              sku: item.product.sku,
              category: item.product.category,
              imageUrl: item.product.imageUrl,
              unitPrice: item.product.price,
              quantity: item.quantity,
              lineTotal: item.total,
            ),
          )
          .toList(),
      subtotal: request.subtotal,
      tax: request.tax,
      total: request.total,
      paymentMethod: request.paymentMethod,
      createdAt: DateTime.now(),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class SaleReceiptItem {
  const SaleReceiptItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.sku,
    this.category,
    this.imageUrl,
  });

  final String productId;
  final String name;
  final String? sku;
  final String? category;
  final String? imageUrl;
  final double unitPrice;
  final int quantity;
  final double lineTotal;

  factory SaleReceiptItem.fromJson(Map<String, dynamic> json) {
    return SaleReceiptItem(
      productId: (json['productId'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      sku: json['sku']?.toString(),
      category: (json['category'] ?? json['categoryName'])?.toString(),
      imageUrl: ApiConstants.resolveServerUrl(
        (json['imageUrl'] ?? json['imageURL'] ?? json['image'])?.toString(),
      ),
      unitPrice: SaleModel._readDouble(json['unitPrice'] ?? json['price']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      lineTotal: SaleModel._readDouble(json['lineTotal'] ?? json['total']),
    );
  }
}
