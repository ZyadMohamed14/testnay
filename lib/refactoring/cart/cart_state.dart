part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

enum CartAction { add, remove, increase, decrease }

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> items;
  final double total;

   CartLoaded(this.items, this.total);

  @override
  List<Object> get props => [items, total];
}

class CartUpdated extends CartState {
  final List<CartModel> items;
  final double total;
  final CartAction action;

  CartUpdated(this.items, this.total, this.action);

  @override
  List<Object> get props => [items, total, action];
}

class CartError extends CartState {}