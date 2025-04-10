part of 'product_cubit.dart';

@immutable
sealed class ProductState {}


@immutable
sealed class LatestProductState {}
class LatestProductLoaded extends ProductState {
  final ProductModel products;

  LatestProductLoaded(this.products);
}
class LatestProductLoading extends ProductState {}
class LatestProductInitial extends ProductState {}
class LatestProductError extends ProductState {
  final String message;

  LatestProductError(this.message);
}


