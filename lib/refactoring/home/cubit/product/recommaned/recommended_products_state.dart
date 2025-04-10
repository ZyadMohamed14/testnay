part of 'recommended_products_cubit.dart';

@immutable
sealed class RecommendedProductsState {}

final class RecommendedProductsInitial extends RecommendedProductsState {}
class RecommendedProductLoaded extends RecommendedProductsState {
  final ProductModel productModel;

  RecommendedProductLoaded(this.productModel);
}
class RecommendedProductLoading extends RecommendedProductsState {}
class RecommendedProductError extends RecommendedProductsState {final String message;
RecommendedProductError(this.message);
}