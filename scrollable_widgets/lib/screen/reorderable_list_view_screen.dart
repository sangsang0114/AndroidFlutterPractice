import 'package:flutter/material.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

import '../const/colors.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({super.key});

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  final List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "ReorderableListViewScreen",
      body: renderBuilder(),
    );
  }

  Widget renderBuilder() {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[numbers[index] % rainbowColors.length],
          index: numbers[index],
        );
      },
      itemCount: numbers.length,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
    );
  }

  Widget renderDefault() {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          /*
            oldIndex와 newIndex 모두 이동되기 전에 선정된다.
            [red, orange, yellow]
            [0, 1, 2]
            red를 yellow 다음으로 이동하고 싶다.

            red : 0 oldIndex -> 3 newIndex
            [orange, yellow, red]

            [red, orange, yellow]
            yellow를 맨 앞으로 옮기고 싶다

            yellow: 2 oldIndex -> 0 newIndex
            [yellow, red, orange]
           */

          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
      children: numbers
          .map(
            (e) => renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
          )
          .toList(),
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);
    return Container(
      key: Key(index.toString()),
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
