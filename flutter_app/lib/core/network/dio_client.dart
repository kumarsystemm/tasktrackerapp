import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.timeout,
    receiveTimeout: ApiConstants.timeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': ApiConstants.apiKey,
    },
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => developer.log(obj.toString()),
  ));

  return dio;
});
