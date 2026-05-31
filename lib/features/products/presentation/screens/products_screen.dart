import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_flutter_desktop/core/network/api_client.dart';
import 'package:pos_flutter_desktop/features/products/data/models/product_model.dart';
import 'package:pos_flutter_desktop/features/products/data/repositories/product_repository.dart';
import 'package:pos_flutter_desktop/features/products/logic/product_cubit.dart';
import 'package:pos_flutter_desktop/features/products/presentation/widgets/product_card.dart';
import 'package:pos_flutter_desktop/features/products/presentation/widgets/product_search_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    required this.onProductSelected,
    this.productRepository,
    super.key,
  });

  final ValueChanged<ProductModel> onProductSelected;
  final ProductRepository? productRepository;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ProductCubit _productCubit;
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productCubit = ProductCubit(
      widget.productRepository ?? ProductRepository(ApiClient()),
    )..loadProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productCubit,
      child: Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductSearchBar(
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                return _CategoryTabs(
                  categories: _categoriesFrom(state.products),
                  selectedCategory: _selectedCategory,
                  onSelected: (category) {
                    setState(() => _selectedCategory = category);
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  return switch (state.status) {
                    ProductStatus.initial || ProductStatus.loading =>
                      const Center(child: CircularProgressIndicator()),
                    ProductStatus.failure => _ProductsErrorView(
                      message: state.errorMessage ?? 'Unable to load products.',
                      onRetry: _productCubit.loadProducts,
                    ),
                    ProductStatus.success => _ProductGrid(
                      products: _visibleProducts(state.products),
                      onProductSelected: widget.onProductSelected,
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _categoriesFrom(List<ProductModel> products) {
    final categories =
        products
            .map((product) => product.category)
            .whereType<String>()
            .where((category) => category.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return categories;
  }

  List<ProductModel> _visibleProducts(List<ProductModel> products) {
    final query = _searchQuery.trim().toLowerCase();

    return products.where((product) {
      final matchesCategory =
          _selectedCategory == null || product.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          (product.sku?.toLowerCase().contains(query) ?? false);

      return matchesCategory && matchesSearch;
    }).toList();
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryButton(
            icon: Icons.grid_view,
            label: 'All Items',
            selected: selectedCategory == null,
            onPressed: () => onSelected(null),
          ),
          for (final category in categories) ...[
            const SizedBox(width: 10),
            _CategoryButton(
              icon: Icons.category_outlined,
              label: category,
              selected: selectedCategory == category,
              onPressed: () => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? const Color(0xFF0B74DE)
        : const Color(0xFFE9EFF6);
    final foregroundColor = selected ? Colors.white : const Color(0xFF0F172A);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19, color: foregroundColor),
              const SizedBox(width: 9),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.onProductSelected});

  final List<ProductModel> products;
  final ValueChanged<ProductModel> onProductSelected;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products found.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
      );
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisExtent: 220,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onPressed: () => onProductSelected(product),
        );
      },
    );
  }
}

class _ProductsErrorView extends StatelessWidget {
  const _ProductsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 46,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 14),
            const Text(
              'Could not load products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF475569)),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
