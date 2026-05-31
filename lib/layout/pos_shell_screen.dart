import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/core/constants/api_constants.dart';
import 'package:pos_flutter_desktop/core/network/api_client.dart';
import 'package:pos_flutter_desktop/features/cart/logic/cart_cubit.dart';
import 'package:pos_flutter_desktop/features/cart/presentation/widgets/cart_panel.dart';
import 'package:pos_flutter_desktop/features/products/data/repositories/product_repository.dart';
import 'package:pos_flutter_desktop/features/products/presentation/screens/products_screen.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/create_sale_request.dart';
import 'package:pos_flutter_desktop/features/sales/data/repositories/sales_repository.dart';
import 'package:pos_flutter_desktop/features/sales/logic/sales_cubit.dart';
import 'package:pos_flutter_desktop/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosShellScreen extends StatefulWidget {
  const PosShellScreen({this.productRepository, super.key});

  final ProductRepository? productRepository;

  @override
  State<PosShellScreen> createState() => _PosShellScreenState();
}

class _PosShellScreenState extends State<PosShellScreen> {
  static const _serverBaseUrlKey = 'server_base_url';

  String _serverBaseUrl = ApiConstants.serverBaseUrl;

  @override
  void initState() {
    super.initState();
    _loadSavedServerBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedServerBaseUrl = ApiConstants.normalizeServerBaseUrl(
      _serverBaseUrl,
    );
    final apiBaseUrl = ApiConstants.apiBaseUrlFor(normalizedServerBaseUrl);

    return KeyedSubtree(
      key: ValueKey(normalizedServerBaseUrl),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CartCubit()),
          BlocProvider(
            create: (_) =>
                SalesCubit(SalesRepository(ApiClient(baseUrl: apiBaseUrl))),
          ),
        ],
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final showOrderPanel = constraints.maxWidth >= 900;

              return Column(
                children: [
                  _TopBar(
                    serverBaseUrl: normalizedServerBaseUrl,
                    onHistoryPressed: () => _openSalesHistory(context),
                    onSettingsPressed: _openSettingsDialog,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ProductsScreen(
                            productRepository:
                                widget.productRepository ??
                                ProductRepository(
                                  ApiClient(baseUrl: apiBaseUrl),
                                  serverBaseUrl: normalizedServerBaseUrl,
                                ),
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
      ),
    );
  }

  Future<void> _openSettingsDialog() async {
    final nextBaseUrl = await showDialog<String>(
      context: context,
      builder: (context) {
        return _SettingsDialog(serverBaseUrl: _serverBaseUrl);
      },
    );

    if (nextBaseUrl == null) return;

    final normalized = ApiConstants.normalizeServerBaseUrl(nextBaseUrl);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_serverBaseUrlKey, normalized);

    setState(() {
      _serverBaseUrl = normalized;
    });
  }

  Future<void> _loadSavedServerBaseUrl() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_serverBaseUrlKey);
    if (saved == null || saved.isEmpty || !mounted) return;

    setState(() {
      _serverBaseUrl = ApiConstants.normalizeServerBaseUrl(saved);
    });
  }

  Future<void> _openSalesHistory(BuildContext context) async {
    final salesCubit = context.read<SalesCubit>();
    await salesCubit.loadSalesHistory();
    if (!context.mounted) return;

    final state = salesCubit.state;
    if (state.status == SalesStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Could not load sales.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => SalesHistoryDialog(sales: state.sales),
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
    await showDialog<void>(
      context: context,
      builder: (_) => ReceiptDialog(sale: sale),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.serverBaseUrl,
    required this.onHistoryPressed,
    required this.onSettingsPressed,
  });

  final String serverBaseUrl;
  final VoidCallback onHistoryPressed;
  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showSessionDetails = constraints.maxWidth >= 920;
        final showSettings = constraints.maxWidth >= 760;

        return Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B74DE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Q',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Point of Sale',
                    style: TextStyle(color: Color(0xFF475569), fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              if (showSessionDetails) ...[
                const Icon(Icons.schedule, size: 21, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                const Text(
                  '05:40 PM',
                  style: TextStyle(fontSize: 15, color: Color(0xFF334155)),
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
                  style: TextStyle(fontSize: 15, color: Color(0xFF334155)),
                ),
                const SizedBox(width: 32),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Cashier',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 13),
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
                  tooltip: 'Sales history',
                  onPressed: onHistoryPressed,
                  icon: const Icon(Icons.receipt_long_outlined),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Settings - $serverBaseUrl',
                  onPressed: onSettingsPressed,
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

class _SettingsDialog extends StatefulWidget {
  const _SettingsDialog({required this.serverBaseUrl});

  final String serverBaseUrl;

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  late final TextEditingController _baseUrlController;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(text: widget.serverBaseUrl);
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _baseUrlController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Base URL',
            hintText: 'https://localhost:7143',
          ),
          onSubmitted: (_) => _save(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _save(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save(BuildContext context) {
    final value = _baseUrlController.text.trim();
    if (value.isEmpty) return;

    Navigator.of(context).pop(value);
  }
}
