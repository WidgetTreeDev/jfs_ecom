import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jfs_ecommerce/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/widget/theme_switcher_button.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search.dart';
import '../../../../core/router/app_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Electronics',
    'Jewelry',
    "Men's Clothing",
    "Women's Clothing",
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                'Find your premium look',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              int count = 0;
                              if (cartState is CartLoaded) {
                                count = cartState.items.fold(
                                  0,
                                  (sum, item) => sum + item.quantity,
                                );
                              }
                              return Badge(
                                offset: const Offset(-2, 2),
                                alignment: Alignment.topRight,
                                label: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                  child: Text(
                                    count.toString(),
                                    key: ValueKey<int>(count),
                                  ),
                                ),
                                isLabelVisible: count > 0,
                                backgroundColor: AppTheme.emeraldGreen,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 28,
                                  ),
                                  onPressed: () => context.push(AppRouter.cart),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (state is ProductLoaded) {
                            showSearch(
                              context: context,
                              delegate: ProductSearchDelegate(
                                products: state.products,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkGray : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Search specific products...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 54,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCategory = category);
                                }
                              },
                              selectedColor: AppTheme.emeraldGreen,
                              backgroundColor: isDark
                                  ? AppTheme.darkGray
                                  : Colors.white,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              showCheckmark: false,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: () async {
                          context.read<ProductBloc>().add(FetchProductsEvent());
                        },
                        child: _buildMainGridContent(state),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              right: 16,
              child: const ThemeSwitcherButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGridContent(ProductState state) {
    if (state is ProductLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const _ShimmerCardPlaceholder(),
      );
    }
    if (state is ProductError) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: ErrorStateWidget(
            lottiePath: 'error.json',
            title: 'Something went wrong',
            subtitle: state.message,
            actionButton: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.emeraldGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () =>
                  context.read<ProductBloc>().add(FetchProductsEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ),
        ),
      );
    }
    if (state is ProductLoaded) {
      final filteredProducts = _selectedCategory == 'All'
          ? state.products
          : state.products
                .where(
                  (p) =>
                      p.category.toLowerCase() ==
                      _selectedCategory.toLowerCase(),
                )
                .toList();

      if (filteredProducts.isEmpty) {
        return ErrorStateWidget(lottiePath: 'ghost.json', title: 'No products found.');
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(product: filteredProducts[index]);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _ShimmerCardPlaceholder extends StatelessWidget {
  const _ShimmerCardPlaceholder();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkGray : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  width: 50,
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
