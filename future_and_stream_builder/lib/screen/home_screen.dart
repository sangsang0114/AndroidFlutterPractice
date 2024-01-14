import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textStyle = TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: streamNumbers(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            /*
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
             */
            if (snapshot.hasData) {
              //데이터가 있을 때 위젯 렌더링
            }
            if (snapshot.hasError) {
              // 에러가 났을 때 위젯 렌더랑
            }
            //로딩 중일 때 위젯 렌더링
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'StreamBuilder',
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 20.0),
                ),
                Text('ConState : ${snapshot.connectionState}',
                    style: textStyle),
                Text(
                  'ConData : ${snapshot.data}',
                  style: textStyle,
                ),
                Text(
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('SetState'))
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));
    final random = Random();
    // throw Exception('에러 발생');
    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for (int i = 0; i < 10; i++) {
      if(i ==5 ){
        throw Exception('i == 5');
      }
      await Future.delayed(Duration(seconds: 3));
      yield i;
    }
  }
}
