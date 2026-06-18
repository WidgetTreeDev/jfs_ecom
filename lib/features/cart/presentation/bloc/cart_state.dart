part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  double get totalAmount => items.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  @override
  List<Object?> get props => [items];
}
