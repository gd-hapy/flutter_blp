import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blp/api/request.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';

//radial-gradient(#0a2e38 0%, #000000 80%)
class Utils {
  static String parseError = 'Parse_video_error';
  static Color themeColor = HexColor('#2e8b57');

  static String searchBarPlaceHolder = '请输入视频名称或链接';

  String randomNum(n) {
    var res = "";
    for (var i = 0; i < n; i++) {
      res += (Random().nextInt(10)).toString();
    }
    return res;
  }

  String randomStr() {
    return randomNum(18);
  }

  String timeStamp() {
    var date = (DateTime.now().millisecondsSinceEpoch).toString();
    return date;
  }

  String customParamCB() {
    return "jQuery182${randomStr()}_${timeStamp()}";
  }

  static String customParam() {
    return '&cb=${Utils().customParamCB()}&_=${Utils().timeStamp()}';
  }
}

class APIPath {
  static String APIPath_home = '/so.php';

  // return 'api.php?out=jsonp&wd='+ keyWords + _customParam()
  static String APIPath_search(keyWords) =>
      'api.php?out=jsonp&wd=' + keyWords + Utils.customParam();

  // return 'api.php?out=jsonp&flag=' + flag + '&id=' + id + _customParam()
  static String APIPath_video(flag, id) =>
      '${'api.php?out=jsonp&flag=' + flag.toString()}&id=' +
      id.toString() +
      Utils.customParam();

  // 解析视频url
  // static String APIPath_parseVideo(playingUrl) =>
  //     'https://json.vipjx.cnow.eu.org/?url=' + playingUrl;
  static String APIPath_parseVideo(playingUrl) =>
      'https://json.2s0.cn:5678/home/api?type=ys&uid=812432&key=cdjmtvxyBDJKOTV027&url=' +
      playingUrl;
  //https://json.2s0.cn:5678/home/api?type=ys&uid=812432&key=cdjmtvxyBDJKOTV027&url=https://v.qq.com/x/cover/tcg7pved74e5mze/d00181klg7v.html?ptag=10523
}

class ApiConfig {
  static List<String> baseList = [
    'https://vip.bljiex.com/',
    'https://www.pouyun.com/',
    'https://movie.heheda.top/',
    'https://jx.qqwtt.com/',
    'https://parse.kbcms.net/',
    'http://vip.momobiji.com/'
  ];
  static String baseUrl = baseList.first;

  static String baseUrlWithReferer = 'https://vip.bljiex.com/';

  static apiConfigChange() {
    var index = baseList.indexOf(baseUrl);
    index += 1;
    index = index % baseList.length;
    baseUrl = baseList[index];
    // EasyLoading.showToast('index: ${baseUrl}');

    HttpUtil.dispose();
    EasyLoading.showToast('当前使用解析：$baseUrl');
  }

  static apiConfigWithReferer(String url) {
    if (url.contains(baseUrlWithReferer)) {
      return baseUrlWithReferer;
    }
    return '';
  }
}

class Adapt {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double ratio = 1.0;
  static double statusBarHeight = 0;
  static double bottomHeight = 0;

  static void initialize(BuildContext context, {double uIWidth = 375}) {
    final mediaQueryData = MediaQuery.of(context);

    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    // 顶部有刘海:47pt 没有刘海的屏幕为20pt
    statusBarHeight = mediaQueryData.padding.top;
    // 底部有刘海:34pt 没有刘海的屏幕0pt
    bottomHeight = mediaQueryData.padding.bottom;
    ratio = screenWidth / uIWidth;
  }

  static pt(size) {
    return size * Adapt.ratio;
  }
}
