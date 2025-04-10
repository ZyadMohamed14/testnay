import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testnay/di_container.dart';

import '../../../app_constants.dart';
import '../../../dio/dio_client.dart';

class ProductRepository{
  DioClient dioClient;
  ProductRepository({required this.dioClient});
  Future<Either<String, ProductModel>>fetchRecommendedProducts()async {
    try {
      final response = await dioClient.get(AppConstants.recommendedProductUri);
      final productModel = ProductModel.fromJson(response.data);



      return Right(productModel); // Success case returns Right with ProductModel
    } catch (e) {
      print("Error fetching Products: $e");
      return Left(e.toString()); // Error case returns Left with error message
    }
  }
  Future<Either<String, ProductModel>> fetchLatestProducts() async {
    try {
      final response = await dioClient.get(AppConstants.latestProductUri);
      final productModel = ProductModel.fromJson(response.data);
      return Right(productModel); // Success case returns Right with ProductModel
    } catch (e) {
      print("Error fetching Products: $e");
      return Left(e.toString()); // Error case returns Left with error message
    }
  }



}