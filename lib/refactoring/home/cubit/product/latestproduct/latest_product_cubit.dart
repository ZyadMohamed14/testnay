import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../di_container.dart';
import '../../../data/product_repository.dart';

part 'latest_product_state.dart';

class LatestProductCubit extends Cubit<LatestProductState> {
  final ProductRepository productRepository;
  LatestProductCubit({required this.productRepository}) : super(LatestProductInitial());

  Future<void> fetchLatestProducts() async {
    try {
      emit(LatestProductLoading()); // Emit loading state

      final response = await productRepository.fetchLatestProducts();

      response.fold(
            (error) => emit(LatestProductError(error)), // Handle Left (error) case
            (productModel) => emit(LatestProductLoaded(productModel)), // Handle Right (success) case
      );
    } catch (e) {
      emit(LatestProductError(e.toString()));
    }
  }
}
