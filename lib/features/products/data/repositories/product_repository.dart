import 'package:pos_flutter_desktop/core/constants/api_constants.dart';
import 'package:pos_flutter_desktop/core/network/api_client.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';

class ProductRepository {
  const ProductRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ProductModel>> fetchProducts() async {
    final data = await _apiClient.get(ApiConstants.products);
    final items = _extractList(data);

    return items
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .where((product) => product.name.isNotEmpty)
        .toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final nestedItems = data['items'] ?? data['data'] ?? data['products'];
      if (nestedItems is List) return nestedItems;
    }

    return const [];
  }
}
