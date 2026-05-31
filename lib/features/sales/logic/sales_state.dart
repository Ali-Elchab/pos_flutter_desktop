part of 'sales_cubit.dart';

enum SalesStatus { initial, loading, success, failure }

class SalesState extends Equatable {
  const SalesState({
    this.status = SalesStatus.initial,
    this.lastSale,
    this.errorMessage,
  });

  final SalesStatus status;
  final SaleModel? lastSale;
  final String? errorMessage;

  SalesState copyWith({
    SalesStatus? status,
    SaleModel? lastSale,
    String? errorMessage,
  }) {
    return SalesState(
      status: status ?? this.status,
      lastSale: lastSale ?? this.lastSale,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lastSale, errorMessage];
}
