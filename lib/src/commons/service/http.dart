import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/commons/service/log.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/screens/splash/splash.dart';

class Http {
  static final Http _instance = Http._init();

  factory Http() => _instance;

  late Dio _dio;

  final baseOptions = BaseOptions(
    baseUrl: HTTP_URL,
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    connectTimeout: 1000 * 60,
  );

  Http._init() {
    // dio init
    _dio = Dio(baseOptions);
    _dio.interceptors.clear();

    // logging
    if (HTTP_DEBUG) {
      _dio.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }

    // add interceptor
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Storage.get(ACCESS_TOKEN);
        final userId = await Storage.get(USER_ID);
        if (token.isNotEmpty) {
          options.headers['X-Auth-Token'] = token;
        }
        if (userId.isNotEmpty) {
          options.headers['X-User-Id'] = userId;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        RequestOptions requestOptions = error.requestOptions;

        // 401 Unauthorized 인증 오류
        if ([401].contains(error.response?.statusCode)) {
          final token = await Storage.get(ACCESS_TOKEN);
          final userId = await Storage.get(USER_ID);

          if (token.isEmpty) {
            Log.print(this, '인증 만료 - token is null');
            gotoLogin();
            return handler.next(error);
          }
          if (userId.isEmpty) {
            Log.print(this, '인증 만료 - userId is null');
            gotoLogin();
            return handler.next(error);
          }
        }

        Response response = Response(
          requestOptions: requestOptions,
          data: {
            'result': false,
            'status': error.response?.statusCode,
          },
          statusCode: 200,
        );
        return handler.resolve(response);
      },
    ));
  }

  void gotoLogin() {
    Log.print(this, '인증 만료 - 로그인 페이지로 이동');
    Storage.removeAll();
    Get.offAll(() => const Splash());
  }

  // static method

  static Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _instance._dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options ??= Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  static Future get(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _instance._dio.get(path,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  static Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _instance._dio.put(path,
        data: data,
        queryParameters: queryParameters,
        options: options ??= Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  static Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _instance._dio.delete(path,
        queryParameters: queryParameters,
        options: options ??= Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        cancelToken: cancelToken);
  }
}
