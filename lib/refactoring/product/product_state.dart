part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
class ProductQuantityUpdated extends ProductState {
  final int quantity;
  final double totalPrice;
  ProductQuantityUpdated(this.quantity, this.totalPrice);
}

