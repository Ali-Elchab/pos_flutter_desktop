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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
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
              if (product.sku != null) ...[
                const SizedBox(height: 4),
                Text(
                  product.sku!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                MoneyFormatter.format(product.price),
                style: const TextStyle(
                  color: Color(0xFF006FE8),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
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
