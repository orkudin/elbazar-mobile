import 'package:dio/dio.dart';

class NetworkException implements Exception{
  late final int? statusCode;
  late final String? message;

  NetworkException({required this.message, this.statusCode});

  factory NetworkException.fromDioError(DioException dioError) {
    final response = dioError.response;
    final message = response?.data['message'] ?? dioError.message;
    final statusCode = response?.statusCode;
    return NetworkException(message: message, statusCode: statusCode);
  }

  @override
  List<Object?> get props => [message, statusCode];
}