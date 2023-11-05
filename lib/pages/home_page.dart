import 'package:flutter_blp/components/custom_button.dart';
import 'package:flutter_blp/components/custom_hot_search.dart';
import 'package:flutter_blp/components/custom_search_bar.dart';
import 'package:flutter_blp/components/custom_time.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../services/home_service.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _homeHotSearch = []; //热门搜索
  var _homeTop100Search = []; //搜索排行榜

  @override
  void initState() {
    super.initState();
    HomeService.homeServiceHotSearchData().then((value) {
      setState(() {
        _homeHotSearch = value.$1;
        _homeTop100Search = value.$2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [HexColor('#0a2e38'), HexColor('#000000')],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CustomTime(),
            const CustomSearchBar(),
            CustomHotSearch(
              hotSearchArray: _homeHotSearch,
              hotSearchTop100Array: _homeTop100Search,
            ),
            const CustomButton(),
          ],
        ),
      ),
    );
  }
}
