

import '../../../app_constants.dart';
import '../../../di_container.dart';
import '../../../dio/dio_client.dart';
import '../../cate_model.dart';


class BannerRepository {
  DioClient dioClient;

  BannerRepository({required this.dioClient});
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await dioClient.get(AppConstants.bannerUri);

      // Convert response data to list of Banner objects
      List<dynamic> data = response.data;
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching banners: $e");
      return [];
    }
  }

}