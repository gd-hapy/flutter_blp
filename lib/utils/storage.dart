import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeysHotSearch {
  hotSearch,
}

enum StorageKeysHotSearchTop100 {
  hotSearchTop100,
}

class Storage {
  // static StorageKeys StorageKeys;
  final SharedPreferences _storage;
  static Future<Storage> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Storage._internal(preferences);
  }

  Storage._internal(this._storage);

  /// 热门搜索
  getHotSearch(StorageKeysHotSearch key) async {
    return _storage.get(key.toString());
  }

  setHotSearch(StorageKeysHotSearch key, List<String> value) async {
    return _storage.setStringList(key.toString(), value);
  }

  /// 热门搜索排行榜
  getHotSearchTop100(StorageKeysHotSearchTop100 key) async {
    return _storage.get(key.toString());
  }

  setHotSearchTop100(StorageKeysHotSearchTop100 key, List<String> value) {
    return _storage.setStringList(key.toString(), value);
  }

  remove(dynamic key) async {
    return _storage.remove(key.toString());
  }
}
