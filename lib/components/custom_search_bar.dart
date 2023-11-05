import 'package:flutter_blp/pages/search_results_page.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String _searchWords = '';

  Widget buildContext(BuildContext context) {
    Size scrSize = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: scrSize.width - 20,
        height: Adapt.pt(120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: scrSize.width - 80 - 10 * 2 - 20 * 2,
              child: TextField(
                onChanged: (value) => _searchWords = value,
                textAlign: TextAlign.justify,
                cursorColor: Utils.themeColor,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
                decoration: InputDecoration(
                    hintText: Utils.searchBarPlaceHolder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                    // 未获取焦点下划线设置为灰色
                    enabledBorder: const OutlineInputBorder(
                      gapPadding: 150,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Utils.themeColor),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0)))),
              ),
            ),
            // Padding(padding: EdgeInsets.only(left: 10)),
            SizedBox(
                width: 80,
                height: 68,
                child: TextButton(
                  onPressed: () {
                    if (_searchWords.isNotEmpty) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchResultsPage(
                          searchWords: _searchWords,
                          searchType: 1,
                        );
                      }));
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(20.0)))),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Utils.themeColor, width: 0.67),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Utils.themeColor),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 20)),
                  ),
                  child: const Text('搜索'),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: buildContext(context),
    );
  }
}
