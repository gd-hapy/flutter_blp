import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../api/request.dart';

class BaseService {
  static requestData(path, {cancelToken}) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    // var response =
    //     await DioRequest.getInstance().dio.get(path, cancelToken: cancelToken);
    var response = await HttpUtil().get(path, cancelToken: cancelToken);
    // var response = await DioRequest.getInstance().get(path);
    EasyLoading.dismiss();
    return response;
  }
}
