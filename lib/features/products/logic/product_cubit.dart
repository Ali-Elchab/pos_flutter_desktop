import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';
import 'package:pos_flutter_desktop/features/products/data/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._repository) : super(const ProductState());

  final ProductRepository _repository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = await _repository.fetchProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
