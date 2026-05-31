import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({
    required this.onChanged,
    required this.onSubmitted,
    required this.onRefresh,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: const InputDecoration(
              hintText: 'Search products by name or barcode...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          tooltip: 'Refresh products',
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
