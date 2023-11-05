import 'package:dio/dio.dart';
import 'package:flutter_blp/utils/utils.dart';

/// dio网络请求配置表 自定义
class DioConfig {
  var baseURL = ApiConfig.baseUrl; //'https://vip.bljiex.com/';
  // 'https://www.pouyun.com/'; //'https://jx.qqwtt.com/'; //域名
  static const timeout = 10000; //超时时间
}

// 网络请求工具类
class DioRequest {
  late Dio dio;
  static DioRequest? _instance;

  /// 构造函数
  DioRequest() {
    dio = Dio();
    dio.options = BaseOptions(
        baseUrl: DioConfig().baseURL,
        connectTimeout: DioConfig.timeout,
        sendTimeout: DioConfig.timeout,
        receiveTimeout: DioConfig.timeout,
        contentType: 'application/json; charset=utf-8',
        responseType: ResponseType.plain,
        headers: {});

    /// 请求拦截器 and 响应拦截机 and 错误处理
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (ApiConfig.apiConfigWithReferer(options.baseUrl) != '') {
        options.headers["Referer"] =
            ApiConfig.apiConfigWithReferer(options.baseUrl);
      }
      print("\n================== 请求数据 ==========================");
      print("url = ${options.uri.toString()}");
      print("headers = ${options.headers}");
      print("params = ${options.data}");
      return handler.next(options);
    }, onResponse: (response, handler) {
      print("\n================== 响应数据 ==========================");
      print("code = ${response.statusCode}");
      // print("data = ${response.data}");
      print("\n");
      handler.next(response);
    }, onError: (DioError e, handler) {
      print("\n================== 错误响应数据 ======================");
      print("type = ${e.type}");
      print("message = ${e.message}");
      print("\n");
      return handler.next(e);
    }));
  }
  static DioRequest getInstance() {
    return _instance ??= DioRequest();
  }

  static dispose() {
    _instance = null;
  }
}
