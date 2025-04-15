import 'package:dio/dio.dart';
import 'package:meal/core/utils/logger.dart';

class DioClient {
  final Dio dio;
  final _logger = Logger();

  DioClient(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}', tag: 'DioClient');
          _logger.d('HEADERS: ${options.headers}', tag: 'DioClient');
          _logger.d('DATA: ${options.data}', tag: 'DioClient');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}', tag: 'DioClient');
          _logger.d('DATA: ${response.data}', tag: 'DioClient');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}', tag: 'DioClient');
          _logger.e('MESSAGE: ${e.message}', tag: 'DioClient');
          _logger.e('ERROR DATA: ${e.response?.data}', tag: 'DioClient');
          return handler.next(e);
        },
      ),
    );
  }
}
