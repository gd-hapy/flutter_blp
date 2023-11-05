import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter_blp/api/request.dart';
import 'package:flutter_blp/models/info_model.dart';
import 'package:flutter_blp/models/video_model.dart';
import 'package:flutter_blp/services/video_service.dart';
import 'package:flutter_blp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final SearchInfoModel infoModel;

  const VideoPlayerPage(this.infoModel, {super.key});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;

  ChewieController? _chewieController;
  VideoModel? _video_play_list;
  var _video_play_url; //当前正在播放的url

  Future? _future;
  Timer? _timer;
  var cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();

    _requestVideoInfoData();
  }

  void _requestVideoInfoData() {
    // EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    _future = Future.delayed(const Duration(seconds: 0), () {
      // 网络请求
      return VideoService.videoServiceGetVideoSearchResultsRequest(
          widget.infoModel.flag, widget.infoModel.id,
          cancelToken: cancelToken);
    }).then((data) {
      //处理返回的接口数据
      _video_play_list = data;
      var playing = _video_play_list!.info.first.video.first;

      _handleVideoPlaying(playing);
    }).onError((error, stackTrace) {
      //请求失败的逻辑
      // EasyLoading.dismiss();
    }).whenComplete(() {
      //无论成功或失败都会走到这里
      // EasyLoading.dismiss();
    });
  }

  void _switchCurrentPlaying(VideoPlaying playing) {
    _handleVideoPlaying(playing);
  }

  _loadLoadingWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      ),
    );
  }

  _videoPlayerIsInitialized() {
    print('_videoPlayerIsInitialized');
    print('定时器已关闭');
    _timer?.cancel();
    setState(() {});
  }

  _loadErrorWidget() {
    return const Center(
      child: Text('数据加载失败，请重试。'),
    );
  }

  var startx = 0.0;
  Duration time = Duration.zero;
  _loadDataWidget(data) {
    return GestureDetector(
      onLongPress: () =>
          {print("onLongPress"), _videoPlayerController?.setPlaybackSpeed(2.0)},
      onLongPressUp: () {
        print("onLongPressUp");
        _videoPlayerController?.setPlaybackSpeed(1.0);
      },
      onPanDown: (details) {
        print("onPanDown:" + details.toString());
        startx = 0.0;
      },
      onPanUpdate: (details) {
        if (0 == startx) {
          startx = details.localPosition.dx;
        }
        var distance = (details.localPosition.dx - startx) * 0.5;
        var percent = distance / MediaQuery.of(context).size.width;
        time = _videoPlayerController!.value.position +
            _videoPlayerController!.value.duration * percent;
        _videoPlayerController?.seekTo(time);

        // print('onPanUpdate:' + details.localPosition.dx.toString());
        // print("onPanUpdate: distance:" + distance.toString());
        // print("onPanUpdate: percent:" + percent.toString());
      },
      onPanStart: (details) {
        // print("onPanStart:" + details.toString());
      },
      onPanEnd: (details) {
        startx = 0;
        // print('onPanEnd');
      },
      onTap: () {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.pause();
        } else {
          _videoPlayerController?.play();
        }
      },
      child: AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      ),
    );
    // return AspectRatio(
    //   aspectRatio: _videoPlayerController!.value.aspectRatio,
    //   child: Chewie(controller: _chewieController!),
    // );
  }

  void _handleVideoPlayer() {
    _disposeVideoPlayer();
    _handleTimer();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(_video_play_url));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoInitialize: true,
      autoPlay: true,
      aspectRatio: 3 / 2.0,
      showControls: true,
    );
  }

  void _handleVideoPlaying(VideoPlaying playing) {
    if (playing.videoUrl.contains('.html')) {
      _parsePlayingUrl(playing);
    } else {
      _video_play_url = playing.videoUrl;
      _handleVideoPlayer();
    }
  }

  void _handleTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      print("定时器已触发");

      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        _videoPlayerIsInitialized();
      }
    });
  }

  void _parsePlayingUrl(VideoPlaying playing) {
    _disposeVideoPlayer();

    // EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    VideoService.videoServiceParseVideoPlayingUrl(playing.videoUrl)
        .then((data) {
      // EasyLoading.dismiss();
      if (data != null) {
        print('_video_play_url:$data');
        setState(() {
          _video_play_url = data;
          var index = _video_play_list!.info.first.video.indexOf(playing);
          _video_play_list!.info.first.video[index].parsedVideoUrl =
              _video_play_url;
        });
        _handleVideoPlayer();
      } else {
        setState(() {
          _video_play_url = Utils.parseError;
          EasyLoading.showError("视频解析异常");
          _loadErrorWidget();
        });
      }
    });
  }

  void _disposeVideoPlayer() {
    if (_videoPlayerController != null) {
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    }
    if (_chewieController != null) {
      _chewieController?.dispose();
      _chewieController = null;
    }
  }

  void _disposeTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    print('dispose');
    _disposeVideoPlayer();
    _disposeTimer();
    HttpUtil().cancelRequests(cancelToken);
    super.dispose();
  }

  Future<Future<int?>> _showCustomModalBottomSheet(
      context, List<VideoInfo> options) async {
    return showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 2.0,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  const Center(
                      // child: Text(''),
                      ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            const Divider(height: 0.3),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: options.first.video
                        .map(
                          (e) => TextButton(
                              onPressed: () {
                                {
                                  Navigator.of(context).pop();

                                  _switchCurrentPlaying(e);
                                }
                              },
                              //设置按钮是否自动获取焦点
                              autofocus: false,
                              //定义一下文本样式
                              style: ButtonStyle(
                                //定义文本的样式 这里设置的颜色是不起作用的
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 18, color: Colors.red)),
                                //设置按钮上字体与图标的颜色
                                //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
                                //更优美的方式来设置
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                            .contains(MaterialState.focused) &&
                                        !states
                                            .contains(MaterialState.pressed)) {
                                      //获取焦点时的颜色
                                      return Utils.themeColor;
                                    } else if (states
                                        .contains(MaterialState.pressed)) {
                                      //按下时的颜色
                                      return Colors.deepPurple;
                                    }
                                    //默认状态使用灰色
                                    return Utils.themeColor;
                                  },
                                ),
                                //背景颜色
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  //设置按下时的背景颜色
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.transparent;
                                  }
                                  //默认不使用背景颜色
                                  return Colors.transparent;
                                }),
                                //设置水波纹颜色
                                overlayColor:
                                    MaterialStateProperty.all(Colors.blue[200]),
                                //设置阴影  不适用于这里的TextButton
                                elevation: MaterialStateProperty.all(0),
                                //设置按钮内边距
                                // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                //设置按钮的大小
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 50)),

                                //设置边框
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Utils.themeColor, width: 1)),

                                //外边框装饰 会覆盖 side 配置的样式
                                // shape: MaterialStateProperty.all(StadiumBorder()),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              child: Container(
                                width: 80,
                                height: 30,
                                alignment: Alignment.center,
                                // padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    [e.videoUrl, e.parsedVideoUrl]
                                            .contains(_video_play_url)
                                        ? Image.asset(
                                            'assets/images/playing.png',
                                            fit: BoxFit.contain,
                                            width: 20,
                                            height: 20,
                                          )
                                        : const Text(''),
                                    Expanded(
                                        child: Center(
                                      child: Text(e.videoName),
                                    ))
                                  ],
                                ),
                              )),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size scrSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(_video_play_list?.title ?? ''),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[
            _video_play_list != null
                ? IconButton(
                    icon: const Icon(Icons.more_horiz),
                    tooltip: "more_horiz",
                    onPressed: () => {
                          _showCustomModalBottomSheet(
                              context, _video_play_list!.info),
                        })
                : const Text('')
          ],
        ),
        body: Container(
          width: scrSize.width,
          height: scrSize.height - 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [HexColor('#0a2e38'), HexColor('#000000')],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              // ignore: prefer_typing_uninitialized_variables
              var widget;
              if (snapshot.connectionState == ConnectionState.done &&
                  _video_play_url != null) {
                if (snapshot.hasError || _video_play_url == Utils.parseError) {
                  widget = _loadErrorWidget();
                } else {
                  if (_videoPlayerController!.value.isInitialized) {
                    widget = _loadDataWidget(snapshot.data);
                  } else {
                    widget = _loadLoadingWidget();
                  }
                }
              } else {
                widget = _loadLoadingWidget();
              }
              return widget;
            },
          ),
        ));
  }
}
