class SearchInfoModel {
  final String flag;
  // ignore: non_constant_identifier_names
  final String flag_name;
  final String from;
  final String id;
  final String title;
  final String type;

  SearchInfoModel(
      this.flag, this.flag_name, this.from, this.id, this.title, this.type);

  SearchInfoModel.fromJson(Map json)
      : flag = json['flag'].toString(),
        flag_name = json['flag_name'],
        from = json['from'],
        id = json['id'],
        title = json['title'],
        type = json['type'];
}
