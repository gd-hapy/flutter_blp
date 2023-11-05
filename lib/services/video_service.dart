import 'dart:convert';
import 'package:flutter_blp/models/video_model.dart';
import 'package:flutter_blp/services/baseService.dart';
import 'package:flutter_blp/utils/utils.dart';

/// 视频播放service
class VideoService {
  /// 获取搜索结果页
  static videoServiceGetVideoSearchResultsRequest(flag, id,
      {cancelToken}) async {
    var requestUrl = APIPath.APIPath_video(flag, id) + Utils.customParam();
    var path = Uri.encodeFull(requestUrl);
    // var response = await DioRequest.getInstance().dio.get(path);
    var response =
        await BaseService.requestData(path, cancelToken: cancelToken);
    if (response.statusCode == 200) {
      var data = response.data.toString();
      var start = Utils().customParamCB().length;
      var res = data.substring(start + 1, data.length - 2);
      var json = jsonDecode(res);
      if (json['success'].toString() == '1') {
        VideoModel videoModel = VideoModel.fromJson(json);
        return videoModel;
      }
    }
  }

  // 视频播放地址解析
  static videoServiceParseVideoPlayingUrl(playingUrl) async {
    var requestUrl = APIPath.APIPath_parseVideo(playingUrl);
    var path = Uri.encodeFull(requestUrl);
    // var response = await DioRequest.getInstance().dio.get(path);
    var response = await BaseService.requestData(path);
    if (response.statusCode == 200) {
      var data = response.data.toString();

      var json = jsonDecode(data);
      return json['url'];
    }
  }
}
