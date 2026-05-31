import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';
import 'package:pos_flutter_desktop/features/products/data/repositories/product_repository.dart';
import 'package:pos_flutter_desktop/layout/pos_shell_screen.dart';

void main() {
  testWidgets('shows the POS shell with backend-loaded products', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PosShellScreen(productRepository: _FakeProductRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('QuickPOS'), findsOneWidget);
    expect(find.text('Search products by name or SKU...'), findsOneWidget);
    expect(find.text('Classic Burger'), findsOneWidget);
  });
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    return const [
      ProductModel(
        id: '1',
        name: 'Classic Burger',
        price: 12.99,
        sku: 'BURGER-001',
        category: 'Food',
      ),
    ];
  }
}
