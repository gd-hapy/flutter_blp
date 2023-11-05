import 'package:flutter_blp/models/search_model.dart';
import 'package:flutter_blp/pages/video_player_page.dart';
import 'package:flutter_blp/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../utils/utils.dart';

class SearchResultsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final searchWords; //搜索词
  // ignore: prefer_typing_uninitialized_variables
  final searchType; // 类型1：搜索结果页  2：搜索排行榜页
  // ignore: prefer_typing_uninitialized_variables
  final searchTop100Array; // 搜索排行榜
  const SearchResultsPage(
      {super.key, this.searchWords, this.searchType, this.searchTop100Array});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  SearchModel? _searchSearchModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.searchType == 1) {
      SearchService.searchServiceGetSearchResultsRequest(widget.searchWords)
          .then((value) {
        setState(() {
          _searchSearchModel = value;
        });
      });
    }
  }

  Widget buildTitle() {
    Widget child;
    if (widget.searchType == 1) {
      //搜索结果页
      child = const Text('搜索结果页');
    } else {
      // 搜索排行榜页
      child = const Text('搜索排行榜-TOP100');
    }
    return Container(
      child: child,
    );
  }

  Widget buildContext(BuildContext context) {
    List<Widget> widgets = []; //先建一个数组用于存放循环生成的widget
    var array = widget.searchType == 1
        ? _searchSearchModel?.info ?? []
        : widget.searchTop100Array;
    for (var item in array) {
      widgets.add(
        TextButton(
          onPressed: () {
            if (widget.searchType == 1) {
              // 搜索结果页
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VideoPlayerPage(
                  item,
                );
              }));
            } else {
              //搜索排行榜页
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchResultsPage(
                  searchType: 1,
                  searchWords: item,
                );
              }));
            }
          },
          //设置按钮是否自动获取焦点
          autofocus: false,
          //定义一下文本样式
          style: ButtonStyle(
            //定义文本的样式 这里设置的颜色是不起作用的
            textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 18, color: Colors.red)),
            //设置按钮上字体与图标的颜色
            //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
            //更优美的方式来设置
            foregroundColor: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.focused) &&
                    !states.contains(MaterialState.pressed)) {
                  //获取焦点时的颜色
                  return Utils.themeColor;
                } else if (states.contains(MaterialState.pressed)) {
                  //按下时的颜色
                  return Colors.deepPurple;
                }
                //默认状态使用灰色
                return Utils.themeColor;
              },
            ),
            //背景颜色
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              //设置按下时的背景颜色
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              //默认不使用背景颜色
              return Colors.transparent;
            }),
            //设置水波纹颜色
            overlayColor: MaterialStateProperty.all(Colors.blue[200]),
            //设置阴影  不适用于这里的TextButton
            elevation: MaterialStateProperty.all(0),
            //设置按钮内边距
            // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
            //设置按钮的大小
            minimumSize: MaterialStateProperty.all(const Size(100, 50)),

            //设置边框
            side: MaterialStateProperty.all(
                BorderSide(color: Utils.themeColor, width: 1)),

            //外边框装饰 会覆盖 side 配置的样式
            // shape: MaterialStateProperty.all(StadiumBorder()),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
          child: widget.searchType == 1
              ? Text(item.title + ' ' + item.from)
              : Text(item),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [Wrap(spacing: 10, runSpacing: 20, children: widgets)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: buildTitle(),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [HexColor('#0a2e38'), HexColor('#000000')],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: buildContext(context),
        ));
  }
}
