import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/data/data_sources/cart_local_data_source.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartLocalDataSource localDataSource;

  CartBloc({required this.localDataSource}) : super(CartLoading()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<IncreaseQuantityEvent>(_onIncreaseQuantity);
    on<DecreaseQuantityEvent>(_onDecreaseQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    final items = await localDataSource.getCartItems();
    emit(CartLoaded(items: items));
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (index >= 0) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity + 1,
        );
      } else {
        currentItems.add(CartItem(product: event.product, quantity: 1));
      }

      await localDataSource.saveCartItems(currentItems);
      emit(CartLoaded(items: currentItems));
    }
  }

  Future<void> _onIncreaseQuantity(
    IncreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.productId,
      );

      if (index >= 0) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity + 1,
        );
        await localDataSource.saveCartItems(currentItems);
        emit(CartLoaded(items: currentItems));
      }
    }
  }

  Future<void> _onDecreaseQuantity(
    DecreaseQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.productId,
      );

      if (index >= 0) {
        if (currentItems[index].quantity > 1) {
          currentItems[index] = currentItems[index].copyWith(
            quantity: currentItems[index].quantity - 1,
          );
        } else {
          currentItems.removeAt(index);
        }
        await localDataSource.saveCartItems(currentItems);
        emit(CartLoaded(items: currentItems));
      }
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      currentItems.removeWhere((item) => item.product.id == event.productId);

      await localDataSource.saveCartItems(currentItems);
      emit(CartLoaded(items: currentItems));
    }
  }
}
