part of 'popular_products_cubit.dart';

@immutable
sealed class PopularProductsState {}

final class PopularProductsInitial extends PopularProductsState {}
class PopularProductsLoaded extends PopularProductsState {
  final ProductModel productModel;

  PopularProductsLoaded(this.productModel);
}
class  PopularProductsLoading extends PopularProductsState {}
class  PopularProductsError extends PopularProductsState {
  final String message;

  PopularProductsError(this.message);
}