import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_cubit.dart';
import 'features/cart/domain/data/data_sources/cart_local_data_source.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  final authBox = await Hive.openBox('auth_box');
  final bool isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);
  runApp(
    MyApp(initialRoute: isLoggedIn ? AppRouter.productList : AppRouter.login),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) =>
              CartBloc(localDataSource: CartLocalDataSourceImpl())
                ..add(LoadCartEvent()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'JFS Ecommerce',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.createRouter(initialRoute),
          );
        },
      ),
    );
  }
}
