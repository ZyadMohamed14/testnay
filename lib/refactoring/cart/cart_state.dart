part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> items;
  final double total;

   CartLoaded(this.items, this.total);

  @override
  List<Object> get props => [items, total];
}

class CartError extends CartState {}