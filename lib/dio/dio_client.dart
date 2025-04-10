import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../app_constants.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.token);
    dio = dioC ?? Dio();

    updateHeader(dioC: dioC, getToken: token);
  } 

  Future<void> updateHeader({String? getToken, Dio? dioC}) async {
    dio
      ?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.followRedirects = true
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "https://web.naycity.org, https://admin.naycity.org",
       // "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        //'branch-id': '${sharedPreferences.getInt(AppConstants.branch)}',
        'branch-id': '${1}',

        'Authorization': 'Bearer $getToken',
      };
    dio?.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      debugPrint(
          'apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          followRedirects: true,
        )
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      log('error get dio: $e');

      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      debugPrint(
          'apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers} \nbody---> $data');

      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint(
        'apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    debugPrint(
        'apiCall ==> url=> $uri \nparams---> $queryParameters\nheader=> ${dio!.options.headers}');

    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }


}


