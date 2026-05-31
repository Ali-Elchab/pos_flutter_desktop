import 'package:flutter/material.dart';
import 'package:pos_flutter_desktop/core/utils/money_formatter.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onPressed,
    super.key,
  });

  final ProductModel product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final outOfStock = product.isOutOfStock;

    return Material(
      color: outOfStock ? const Color(0xFFF8FAFC) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: outOfStock ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD7DEE8)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProductImage(imageUrl: product.imageUrl),
              const SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (product.category != null) ...[
                const SizedBox(height: 6),
                Text(
                  product.category!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0B74DE),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (product.barcode != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.barcode!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    MoneyFormatter.format(product.price),
                    style: const TextStyle(
                      color: Color(0xFF006FE8),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StockBadge(stockQuantity: product.stockQuantity),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stockQuantity});

  final int stockQuantity;

  @override
  Widget build(BuildContext context) {
    final out = stockQuantity <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: out ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        out ? 'Out' : '$stockQuantity',
        style: TextStyle(
          color: out ? const Color(0xFFB91C1C) : const Color(0xFF166534),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 58,
        height: 58,
        color: const Color(0xFFEFF6FF),
        child: url == null || url.isEmpty
            ? const Icon(
                Icons.inventory_2_outlined,
                size: 34,
                color: Color(0xFF0B74DE),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image_outlined,
                    size: 34,
                    color: Color(0xFF94A3B8),
                  );
                },
              ),
      ),
    );
  }
}
