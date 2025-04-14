part of 'latest_product_cubit.dart';

@immutable
sealed class LatestProductState {}
class LatestProductLoaded extends LatestProductState {
  final ProductModel productModel;

  LatestProductLoaded(this.productModel);
}
class LatestProductLoading extends LatestProductState {}
class LatestProductInitial extends LatestProductState {}
class LatestProductError extends LatestProductState {
  final String message;

  LatestProductError(this.message);
}

