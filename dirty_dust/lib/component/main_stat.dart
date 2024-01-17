import 'package:flutter/material.dart';

class MainStat extends StatelessWidget {
  //미세먼지 / 초미세먼지용
  final String category;

  //이미지 위치
  final String imgPath;

  //오염 정도
  final String level;

  //수치
  final String stat;

  final double width;

  const MainStat({
    super.key,
    required this.category,
    required this.imgPath,
    required this.level,
    required this.stat,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      color: Colors.black,
    );
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category, style: ts),
          SizedBox(height: 8.0),
          Image.asset(
            imgPath,
            width: 50.0,
          ),
          SizedBox(height: 8.0),
          Text(level, style: ts),
          Text(stat, style: ts),
        ],
      ),
    );
  }
}
