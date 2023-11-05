import 'dart:convert';
import 'package:flutter_blp/models/search_model.dart';
import 'package:flutter_blp/services/baseService.dart';
import 'package:flutter_blp/utils/utils.dart';

/// 搜索service
class SearchService {
  /// 获取搜索结果页
  static searchServiceGetSearchResultsRequest(keywords) async {
    var requestUrl = APIPath.APIPath_search(keywords);
    var path = Uri.encodeFull(requestUrl);
    // var response = await DioRequest.getInstance().dio.get(path);
    var response = await BaseService.requestData(path);
    if (response.statusCode == 200) {
      var data = response.data.toString();
      var start = Utils().customParamCB().length + 1;
      var res = data.substring(start, data.length - 2);
      var json = jsonDecode(res);
      if (json['success'].toString() == '1') {
        SearchModel searchModel = SearchModel.fromJson(json);
        return searchModel;
      }
    }
  }
}
