import 'package:flutter_blp/models/info_model.dart';

class SearchModel {
  final String code;
  final List<SearchInfoModel> info;
  final String success;
  final String title;

  SearchModel(this.code, this.info, this.success, this.title);

  SearchModel.fromJson(Map json)
      : code = json['code'].toString(),
        info = List<SearchInfoModel>.from(
            json["info"].map((x) => SearchInfoModel.fromJson(x))),
        success = json['success'].toString(),
        title = json['title'];
}
