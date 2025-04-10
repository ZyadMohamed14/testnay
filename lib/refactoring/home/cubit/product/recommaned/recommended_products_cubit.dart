import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../di_container.dart';
import '../../../data/product_repository.dart';

part 'recommended_products_state.dart';

class RecommendedProductsCubit extends Cubit<RecommendedProductsState> {
  final ProductRepository productRepository;


  RecommendedProductsCubit({required this.productRepository}) : super(RecommendedProductsInitial());

  Future<void> fetchRecommendedProducts() async {
    try {
      emit(RecommendedProductLoading()); // Emit loading state

      final response = await productRepository.fetchRecommendedProducts();

      response.fold(
            (error) => emit(RecommendedProductError(error)), // Handle Left (error) case
            (productModel) => emit(RecommendedProductLoaded(productModel)), // Handle Right (success) case
      );
    } catch (e) {
      emit(RecommendedProductError(e.toString()));
    }
  }

}
