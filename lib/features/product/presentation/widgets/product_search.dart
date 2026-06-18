import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jfs_ecommerce/core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../../../../core/router/app_router.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate({required this.products});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildFilteredList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildFilteredList();
  }

  Widget _buildFilteredList() {
    final filtered = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No products match your search.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => Divider(
        indent: 84,
        height: 1,
        color: Theme.of(context).dividerColor.withOpacity(0.05),
      ),
      itemBuilder: (context, index) {
        final product = filtered[index];
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return InkWell(
          onTap: () {
            close(context, null);
            context.push(AppRouter.productDetail, extra: product);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkGray : AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppTheme.charcoal : Colors.grey[100],
                        child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.hintColor.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}