import 'package:testnay/refactoring/cate_model.dart';

import '../../../app_constants.dart';
import '../../../dio/dio_client.dart';

class CategoryRepository {
  DioClient dioClient;

  CategoryRepository({required this.dioClient});
  Future<List<CategoryModel>> fetchCategories() async {


    try {
      final response = await dioClient.get(AppConstants.categoryUri);

      List<dynamic> data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching caggories: $e");
      return [];
    }
  }
}