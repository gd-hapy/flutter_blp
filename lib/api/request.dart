import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../utils/utils.dart';

class UtilConfig {
  var baseURL = ApiConfig.baseUrl;
  static const timeout = 10000; //超时时间
}

class HttpUtil {
  static HttpUtil? _instance;
  late Dio dio;

  CancelToken cancelToken = CancelToken();

  static HttpUtil? getInstance() {
    return _instance ??= HttpUtil();
  }

  /*
   * config it and create
   */
  /// 构造函数
  HttpUtil() {
    dio = Dio();
    dio.options = BaseOptions(
        baseUrl: UtilConfig().baseURL,
        connectTimeout: UtilConfig.timeout,
        sendTimeout: UtilConfig.timeout,
        receiveTimeout: UtilConfig.timeout,
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

  /*
   * get请求
   */
  get(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
      EasyLoading.dismiss();
    }
    return response;
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      response = await dio.post(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response? response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  static dispose() {
    _instance = null;
  }
}
