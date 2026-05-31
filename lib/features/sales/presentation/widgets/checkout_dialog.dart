import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_flutter_desktop/core/utils/money_formatter.dart';
import 'package:pos_flutter_desktop/features/sales/data/models/sale_model.dart';

class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({required this.sale, super.key});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    final createdAt = sale.createdAt;

    return AlertDialog(
      title: const Text('Receipt'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                sale.id.isEmpty ? 'Sale completed' : 'Sale #${sale.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy - h:mm a').format(createdAt),
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
              const SizedBox(height: 18),
              for (final item in sale.items) _ReceiptItemRow(item: item),
              const Divider(height: 28),
              _ReceiptTotalRow(label: 'Subtotal', value: sale.subtotal),
              _ReceiptTotalRow(label: 'Tax', value: sale.tax),
              _ReceiptTotalRow(
                label: 'Total',
                value: sale.total,
                emphasized: true,
              ),
              _ReceiptTotalRow(label: 'Paid', value: sale.amountPaid),
              _ReceiptTotalRow(label: 'Change', value: sale.changeDue),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.print_outlined),
          label: const Text('Print'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class SalesHistoryDialog extends StatelessWidget {
  const SalesHistoryDialog({required this.sales, super.key});

  final List<SaleModel> sales;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sales History'),
      content: SizedBox(
        width: 640,
        height: 520,
        child: sales.isEmpty
            ? const Center(child: Text('No sales yet.'))
            : ListView.separated(
                itemCount: sales.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  final createdAt = sale.createdAt;

                  return ListTile(
                    title: Text('Sale #${sale.id}'),
                    subtitle: Text(
                      [
                        if (createdAt != null)
                          DateFormat('MMM d, yyyy - h:mm a').format(createdAt),
                        '${sale.items.length} lines',
                      ].join(' - '),
                    ),
                    trailing: Text(
                      MoneyFormatter.format(sale.total),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => ReceiptDialog(sale: sale),
                      );
                    },
                  );
                },
              ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ReceiptItemRow extends StatelessWidget {
  const _ReceiptItemRow({required this.item});

  final SaleReceiptItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.name} x${item.quantity}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(MoneyFormatter.format(item.lineTotal)),
        ],
      ),
    );
  }
}

class _ReceiptTotalRow extends StatelessWidget {
  const _ReceiptTotalRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final double value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasized ? 18 : 14,
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(MoneyFormatter.format(value), style: style),
        ],
      ),
    );
  }
}
