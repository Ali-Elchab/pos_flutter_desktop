import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/core/network/api_client.dart';
import 'package:pos_flutter_desktop/features/cart/logic/cart_cubit.dart';
import 'package:pos_flutter_desktop/features/cart/presentation/widgets/cart_panel.dart';
import 'package:pos_flutter_desktop/features/products/data/repositories/product_repository.dart';
import 'package:pos_flutter_desktop/features/products/presentation/screens/products_screen.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/create_sale_request.dart';
import 'package:pos_flutter_desktop/features/sales/data/repositories/sales_repository.dart';
import 'package:pos_flutter_desktop/features/sales/logic/sales_cubit.dart';

class PosShellScreen extends StatelessWidget {
  const PosShellScreen({this.productRepository, super.key});

  final ProductRepository? productRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => SalesCubit(SalesRepository(ApiClient()))),
      ],
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final showOrderPanel = constraints.maxWidth >= 900;

            return Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ProductsScreen(
                          productRepository: productRepository,
                          onProductSelected: context
                              .read<CartCubit>()
                              .addProduct,
                        ),
                      ),
                      if (showOrderPanel)
                        SizedBox(
                          width: 420,
                          child: BlocBuilder<SalesCubit, SalesState>(
                            builder: (context, salesState) {
                              return BlocBuilder<CartCubit, CartState>(
                                builder: (context, cartState) {
                                  final cartCubit = context.read<CartCubit>();

                                  return CartPanel(
                                    state: cartState,
                                    onAdd: cartCubit.increaseItem,
                                    onRemove: cartCubit.decreaseItem,
                                    onClear: cartCubit.clear,
                                    onPaymentMethodChanged:
                                        cartCubit.selectPaymentMethod,
                                    onPay: () => _pay(context, cartState),
                                    isPaying:
                                        salesState.status ==
                                        SalesStatus.loading,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pay(BuildContext context, CartState cartState) async {
    if (cartState.items.isEmpty) return;

    final request = CreateSaleRequest(
      items: cartState.items,
      subtotal: cartState.subtotal,
      tax: cartState.tax,
      total: cartState.total,
      paymentMethod: cartState.paymentMethod.label,
    );

    final sale = await context.read<SalesCubit>().createSale(request);
    if (!context.mounted) return;

    if (sale == null) {
      final message = context.read<SalesCubit>().state.errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Could not complete sale.')),
      );
      return;
    }

    context.read<CartCubit>().clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sale completed.')));
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showSessionDetails = constraints.maxWidth >= 920;
        final showSettings = constraints.maxWidth >= 760;

        return Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B74DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Q',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QuickPOS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Point of Sale',
                    style: TextStyle(color: Color(0xFF475569), fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              if (showSessionDetails) ...[
                const Icon(Icons.schedule, size: 21, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                const Text(
                  '05:40 PM',
                  style: TextStyle(fontSize: 16, color: Color(0xFF334155)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: SizedBox(
                    height: 24,
                    child: VerticalDivider(color: Color(0xFFCBD5E1)),
                  ),
                ),
                const Text(
                  'Sunday, May 31',
                  style: TextStyle(fontSize: 16, color: Color(0xFF334155)),
                ),
                const SizedBox(width: 32),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Cashier',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
              ],
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.person_outline),
              ),
              if (showSettings) ...[
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
