import 'package:flutter_blp/services/baseService.dart';
import 'package:flutter_blp/utils/utils.dart';
import 'package:html/parser.dart';
import '../utils/storage.dart';

class HomeService {
  /// 获取热门推荐数据
  static homeServiceHotSearchRequest() async {
    // var response = await DioRequest().dio.get(APIPath.APIPath_home);
    var response = await BaseService.requestData(APIPath.APIPath_home);
    if (response.statusCode == 200) {
      var data = response.toString();

      final arr = data.split('title="');
      arr.removeAt(0);

      final top100Data = arr.map((item) {
        return item.split('";')[0];
      }).toList();

      var document = parse(data);

      List<String> tmpHotSearch = [];

      document.getElementsByTagName("a").forEach((element) {
        tmpHotSearch.add(element.text);
      });

      final hotData = tmpHotSearch.getRange(0, 6).toList();
      hotData.insert(0, '热门搜索:');

      //  缓存数据
      Storage store = await Storage.getInstance(); //初始化

      await store.setHotSearch(
          StorageKeysHotSearch.hotSearch, hotData); //调用写入方法

      await store.setHotSearchTop100(
          StorageKeysHotSearchTop100.hotSearchTop100, top100Data); //调用写入方法

      return (hotData, top100Data);
    }
  }

  static homeServiceHotSearchData() async {
    DateTime now = DateTime.now();
    if (now.day % 10 == 0) {
      return homeServiceHotSearchRequest();
    } else {
      Storage store = await Storage.getInstance(); //初始化

      var hotSearch = await store.getHotSearch(StorageKeysHotSearch.hotSearch);

      var searchTop100 = await store
          .getHotSearchTop100(StorageKeysHotSearchTop100.hotSearchTop100);
      if (hotSearch == null || searchTop100 == null) {
        return homeServiceHotSearchRequest();
      }
      return (hotSearch, searchTop100);
    }
  }
}
