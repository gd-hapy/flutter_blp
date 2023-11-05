import 'dart:async';
import 'package:flutter_blp/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTime extends StatefulWidget {
  const CustomTime({super.key});

  @override
  State<CustomTime> createState() => _CustomTime();
}

class _CustomTime extends State<CustomTime> {
  late Timer _timer;

  var _currentDate = '0000:00:00'; //日期
  var _currentTime = '00:00:00'; //时间

  @override
  void initState() {
    super.initState();

    // /循环执行
    // /间隔1秒
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      DateTime now = DateTime.now();
      _currentDate =
          '${now.year}:${now.month.toString().padLeft(2, '0')}:${now.day.toString().padLeft(2, '0')}';
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      // print('当前时间：${now.toString()}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    ///取消计时器
    _timer.cancel();
    super.dispose();
  }

  Widget buildContext(BuildContext context) {
    Size srcSize = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.only(top: 0),
          width: srcSize.width - 20,
          height: Adapt.pt(180),
          // decoration: const BoxDecoration(color: Colors.green),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _currentDate,
                style: const TextStyle(fontSize: 50, color: Colors.white
                    // backgroundColor: Colors.red,
                    ),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                _currentTime,
                style: const TextStyle(
                    fontSize: 25,
                    // backgroundColor: Colors.brown,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: buildContext(context),
    );
  }
}
