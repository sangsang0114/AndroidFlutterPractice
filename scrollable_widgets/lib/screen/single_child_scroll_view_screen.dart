import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  SingleChildScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'singleChildScrollView',
      body: renderPerformance(),
    );
  }

  Widget renderContainer({
    required Color color,
    int? index,
  }) {
    if (index != null) {
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }

  //1
  //기본 렌더링법
  Widget renderSimple() {
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(
                color: e,
              ),
            )
            .toList(),
      ),
    );
  }

  //2
  //화면을 넘어가지 않아도 스크롤 되게 하기
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      //아이폰에선 아래 하나만 넣으면 되지만
      // physics: AlwaysScrollableScrollPhysics(),

      //안드로이드에선 이걸 넣어야 함
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //기본값 NeverScrollableScrollPhysics
      child: Column(
        children: [
          renderContainer(color: Colors.red),
        ],
      ),
    );
  }

  //3
//위젯이 잘리지 않게 하기
  Widget renderClip() {
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias, //잘렸을 때 어떤 방식으로

      //NeverScrollableScrollPhtsics - 스크롤 안 됨
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          renderContainer(color: Colors.green),
        ],
      ),
    );
  }

  //4
  //여러가지 Physics
  Widget renderPhysics() {
    return SingleChildScrollView(
      //NeverScrollableScrollPhtsics - 스크롤 안 됨
      //AlwaysScrollableScrollPhysics - 스크롤 됨
      //BouncingScrollPhysics - ios 스타일로 튕기는 효과 가능
      //ClampingScrollPhysics - 안드로이드 스타일로 튕기는 효과 X
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(
                color: e,
              ),
            )
            .toList(),
      ),
    );
  }

  //5
  //SingleChildView 퍼포먼스
  Widget renderPerformance() {
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
