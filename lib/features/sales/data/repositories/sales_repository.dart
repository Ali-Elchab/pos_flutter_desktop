import 'package:pos_flutter_desktop/core/constants/api_constants.dart';
import 'package:pos_flutter_desktop/core/network/api_client.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/create_sale_request.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/sale_model.dart';

class SalesRepository {
  const SalesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<SaleModel> createSale(CreateSaleRequest request) async {
    final data = await _apiClient.post(
      ApiConstants.salesCheckout,
      data: request.toJson(),
    );

    if (data is Map<String, dynamic>) {
      final saleData = data['sale'] ?? data['data'] ?? data;
      if (saleData is Map<String, dynamic>) {
        return SaleModel.fromJson(saleData);
      }
    }

    return SaleModel.fromRequest(request);
  }

  Future<List<SaleModel>> fetchSales({int take = 20}) async {
    final data = await _apiClient.get(
      ApiConstants.sales,
      queryParameters: {'take': take},
    );

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(SaleModel.fromJson)
          .toList();
    }

    return const [];
  }
}
