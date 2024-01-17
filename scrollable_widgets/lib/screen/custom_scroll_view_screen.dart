import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  double get maxExtent => maxHeight; //최대 높이

  @override
  double get minExtent => minHeight; //최소 높이

  //covariant : 상속된 클래스도 사용 가능
  //oldDelegate : build가 실행되엇을 때 이전 Delegate
  // this : 새로운 Delegate
  //should Rebuild : 새로 빌드를 해야될지 결정
  //false : 빌드 안함. true : 빌드 다시 함
  @override
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }
}

//모든 ListView는 Column안에 쓸 경우 Expanded로 감싼 상태여야 함
class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //Sliver위젯을 넣어줘야함. ListView 넣으면 오류 발생
          renderSliverAppBar(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderHeader(),
          renderBuilderSilverList(),
          renderHeader(),
        ],
      ),
    );
  }

  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverFixedHeaderDelegate(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Text(
                '신기하지~~',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          maxHeight: 200,
          minHeight: 100),
    );
  }

  // AppBar
  SliverAppBar renderSliverAppBar() {
    return SliverAppBar(
      //스크롫 했을 때 리스트의 중간에도 AppBar가 내려오게 할 수 있다
      floating: true,

      //완전 고정
      pinned: false,

      // 자석 효과. floating이 true일 경우에만 사용 가능
      snap: true,

      // ios에서 맨 위에서 한계 이상으로 스크롤 했을 때 남는 공간을 차지
      stretch: true,

      expandedHeight: 200,
      collapsedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('FlexibleSpace'),
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
      ),
      title: Text('CustomScrollViewScreen'),
    );
  }

  //GridView.builder와 비슷함
  SliverGrid renderSliverGridBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(color: rainbowColors[index % 7], index: index);
        },
        childCount: 100,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }

  //Gridview.count 유사함
  SliverGrid renderChildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(color: rainbowColors[e % 7], index: e),
            )
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  // ListView.Builder 생성자와 비슷
  SliverList renderBuilderSilverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 100,
        (context, index) {
          return renderContainer(color: rainbowColors[index % 7], index: index);
        },
      ),
    );
  }

  // ListView 기본생성자와 비슷
  SliverList renderChildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(color: rainbowColors[e % 7], index: e),
            )
            .toList(),
      ),
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);
    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
