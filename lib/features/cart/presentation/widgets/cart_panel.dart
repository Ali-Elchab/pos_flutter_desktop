import 'package:flutter/material.dart';
import 'package:pos_flutter_desktop/core/utils/money_formatter.dart';
import 'package:pos_flutter_desktop/features/cart/data/models/cart_item_model.dart';
import 'package:pos_flutter_desktop/features/cart/logic/cart_cubit.dart';
import 'package:pos_flutter_desktop/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:pos_flutter_desktop/features/cart/presentation/widgets/cart_totals.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({
    required this.state,
    required this.onAdd,
    required this.onRemove,
    required this.onClear,
    super.key,
  });

  final CartState state;
  final ValueChanged<CartItemModel> onAdd;
  final ValueChanged<CartItemModel> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF0B74DE),
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Current Order',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.items.isEmpty
                ? const _EmptyCartView()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemTile(
                        item: item,
                        onAdd: () => onAdd(item),
                        onRemove: () => onRemove(item),
                      );
                    },
                  ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CartTotals(
                    itemCount: state.itemCount,
                    subtotal: state.subtotal,
                    tax: state.tax,
                    total: state.total,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: _PaymentMethod(icon: Icons.money, label: 'Cash'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _PaymentMethod(
                          icon: Icons.credit_card,
                          label: 'Card',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _PaymentMethod(
                          icon: Icons.phone_android,
                          label: 'Mobile',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.items.isEmpty ? null : onClear,
                          child: const Text('Clear Cart'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: state.items.isEmpty ? null : () {},
                          child: Text(
                            'Pay ${MoneyFormatter.format(state.total)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 46,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 14),
            Text(
              'Cart is empty',
              style: TextStyle(fontSize: 16, color: Color(0xFF334155)),
            ),
            SizedBox(height: 4),
            Text(
              'Add items to get started',
              style: TextStyle(color: Color(0xFF475569)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  const _PaymentMethod({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF64748B),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 19),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
