import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/create_sale_request.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/sale_model.dart';
import 'package:pos_flutter_desktop/features/sales/data/repositories/sales_repository.dart';

part 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit(this._repository) : super(const SalesState());

  final SalesRepository _repository;

  Future<SaleModel?> createSale(CreateSaleRequest request) async {
    emit(state.copyWith(status: SalesStatus.loading));

    try {
      final sale = await _repository.createSale(request);
      emit(state.copyWith(status: SalesStatus.success, lastSale: sale));
      return sale;
    } catch (error) {
      emit(
        state.copyWith(
          status: SalesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return null;
    }
  }

  Future<void> loadSalesHistory() async {
    emit(state.copyWith(status: SalesStatus.loading));

    try {
      final sales = await _repository.fetchSales();
      emit(state.copyWith(status: SalesStatus.success, sales: sales));
    } catch (error) {
      emit(
        state.copyWith(
          status: SalesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: SalesStatus.initial));
  }
}
