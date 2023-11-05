import 'package:flutter_blp/pages/search_results_page.dart';
import 'package:flutter_blp/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomHotSearch extends StatelessWidget {
  final hotSearchArray;
  final hotSearchTop100Array;
  const CustomHotSearch(
      {super.key, this.hotSearchArray, this.hotSearchTop100Array});

  Widget buildContext(BuildContext context) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in hotSearchArray) {
      tiles.add(InkWell(
        child: Text(item,
            style: const TextStyle(
              color: Color.fromARGB(255, 8, 134, 13),
              fontSize: 20,
              // backgroundColor: Colors.grey,
            )),
        onTap: () {
          if (item.toString().contains('热门搜索')) {
            return;
          }
          var type = 1;
          if (item.contains('更多')) {
            type = 2;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchResultsPage(
              searchWords: item,
              searchType: type,
              searchTop100Array: hotSearchTop100Array,
            );
          }));
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return BrowserPage(
          //     url: '',
          //   );
          //   return BrowserPage(
          //       url:
          //           'https://jx.qqwtt.com/?url=https://v.qq.com/x/cover/tcg7pved74e5mze/d00181klg7v.html?ptag=10523');
          //   // BrowserPage(
          //   //     url:
          //   //         'https://v.qq.com/HSTSx/cover/tcg7pved74e5mze/d00181klg7v.html?ptag=10523',
          //   //     );
          // }));
        },
      ));
    }

    return Wrap(
      direction: Axis.horizontal,
      spacing: 20,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: tiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size scrSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 10),
        width: scrSize.width - 20,
        height: Adapt.pt(200),
        color: Colors.transparent,
        child: buildContext(context),
      ),
    );
  }
}
