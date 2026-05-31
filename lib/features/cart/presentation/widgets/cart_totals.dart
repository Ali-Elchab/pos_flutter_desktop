import 'package:flutter/material.dart';
import 'package:pos_flutter_desktop/core/utils/money_formatter.dart';

class CartTotals extends StatelessWidget {
  const CartTotals({
    required this.itemCount,
    required this.subtotal,
    required this.tax,
    required this.total,
    super.key,
  });

  final int itemCount;
  final double subtotal;
  final double tax;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 14),
        _SummaryRow(
          label: 'Subtotal ($itemCount items)',
          value: MoneyFormatter.format(subtotal),
        ),
        const SizedBox(height: 14),
        _SummaryRow(label: 'Tax (11%)', value: MoneyFormatter.format(tax)),
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Total',
          value: MoneyFormatter.format(total),
          emphasized: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasized ? 22 : 16,
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w400,
      color: emphasized ? const Color(0xFF020617) : const Color(0xFF334155),
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(
          value,
          style: style.copyWith(
            color: emphasized ? const Color(0xFF006FE8) : style.color,
          ),
        ),
      ],
    );
  }
}
