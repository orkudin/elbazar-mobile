import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({Dio? dio})
      : dio = dio ?? Dio(
          BaseOptions(
            baseUrl: 'https://daurendan.ru/',
            connectTimeout: Duration(seconds: 5000),
            receiveTimeout: Duration(seconds: 3000),
          ),
        );
}