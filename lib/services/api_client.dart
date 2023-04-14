import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final _dio = Dio();
  ApiClient() {
    _dio.options.baseUrl = 'https://reqres.in/';
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;
}