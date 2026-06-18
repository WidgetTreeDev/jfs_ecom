part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  const AddToCartEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class IncreaseQuantityEvent extends CartEvent {
  final int productId;
  const IncreaseQuantityEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class DecreaseQuantityEvent extends CartEvent {
  final int productId;
  const DecreaseQuantityEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  const RemoveFromCartEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}
