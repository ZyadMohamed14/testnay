import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../cate_model.dart';
import '../../data/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;


  CategoryCubit({required this.categoryRepository}) : super(CategoryInitial());
  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading()); // Emit loading state
      //await Future.delayed(Duration(seconds: 10));
      final categories = await categoryRepository.fetchCategories();
      emit(CategoryLoaded(categories)); // Emit success state with fetched banners
    } catch (e) {
      emit(CategoryError(e.toString())); // Emit error state if something goes wrong
    }
  }
}
