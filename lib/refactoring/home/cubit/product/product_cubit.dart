import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/home/data/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;


  ProductCubit({required this.productRepository}) : super(LatestProductInitial());


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