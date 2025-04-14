import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../di_container.dart';
import '../../../data/product_repository.dart';

part 'popular_products_state.dart';

class PopularProductsCubit extends Cubit<PopularProductsState> {
  final ProductRepository productRepository;

  PopularProductsCubit({required this.productRepository})
    : super(PopularProductsInitial());

  Future<void> fetchLatestProducts() async {
    try {
      emit(PopularProductsLoading()); // Emit loading state

      final response = await productRepository.fetchPopularProducts();

      response.fold(
        (error) => emit(PopularProductsError(error)),
        // Handle Left (error) case
        (productModel) => emit(
          PopularProductsLoaded(productModel),
        ), // Handle Right (success) case
      );
    } catch (e) {
      emit(PopularProductsError(e.toString()));
    }
  }
}
