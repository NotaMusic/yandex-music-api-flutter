import 'package:dio/dio.dart';

class DioMusicInterceptor extends Interceptor {
  DioMusicInterceptor({this.token});

  final String? token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'X-Yandex-Music-Client': 'YandexMusicAndroid/23020251',
      if (token != null) 'Authorization': 'OAuth $token',
    });
    handler.next(options);
  }
}
