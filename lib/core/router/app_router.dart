import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/product/data/data_sources/product_remote_data_source.dart';
import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String productList = '/products';
  static const String productDetail = '/products/detail';
  static const String cart = '/cart';

  static GoRouter createRouter(String initialRoute) {
    return GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(path: login, builder: (context, state) => const LoginScreen()),
        GoRoute(
          path: productList,
          builder: (context, state) =>
              BlocProvider(
                create: (context) =>
                    ProductBloc(
                      remoteDataSource: ProductRemoteDataSourceImpl(
                        client: http.Client(),
                      ),
                    ),
                child: const ProductListScreen(),
              ),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final product = state.extra as Product;
                return ProductDetailScreen(product: product);
              },
            ),
          ],
        ),
        GoRoute(
          path: cart,
          builder: (context, state) => const CartScreen(),
        ),
      ],
      errorBuilder: (context, state) =>
          Scaffold(body: Center(child: Text('Route Error: ${state.error}'))),
    );
  }
}
