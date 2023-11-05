class VideoModel {
  final String success;
  final String code;
  final String url;
  final String pic;
  final String title;
  final String part;
  final String type;
  final List<VideoInfo> info;

  VideoModel(this.success, this.code, this.url, this.pic, this.title, this.part,
      this.type, this.info);

  VideoModel.fromJson(Map json)
      : success = json['success'].toString(),
        code = json['code'].toString(),
        url = json['url'],
        pic = json['pic'],
        title = json['title'],
        part = json['part'].toString(),
        type = json['type'],
        info = //List<VideoInfo>.from(json['info']) json['info'].map((item) => VideoInfo.fromJson(item)).toList();
            List<VideoInfo>.from(
                json["info"].map((x) => VideoInfo.fromJson(x)));
}

class VideoInfo {
  final String flag;
  final String flag_name;
  final String part;
  final List<VideoPlaying> video;
  VideoInfo(this.flag, this.flag_name, this.part, this.video);
  VideoInfo.fromJson(Map json)
      : flag = json['flag'],
        flag_name = json['flag_name'],
        part = json['part'].toString(),
        video = List<VideoPlaying>.from(
            json["video"].map((x) => VideoPlaying.fromJson(x)));
}

class VideoPlaying {
  final String videoName;
  final String videoUrl;
  final String videoFullUrl;
  String parsedVideoUrl = '';

  VideoPlaying(this.videoName, this.videoUrl, this.videoFullUrl);

  VideoPlaying.fromJson(String json)
      : videoName = json.split('\$')[0],
        videoUrl = json.split('\$')[1],
        videoFullUrl = json;
}
