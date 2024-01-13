import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope ( //시스템 뒤로 막기 버튼 차단
      onWillPop: () async{
        //true - pop 가능
        //false - pop 불가능
        final canPop = Navigator.of(context).canPop();

        return false;
      },
      child: MainLayout(
        title: 'HomeScreen',
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => RouteOneScreen(
                    number: 123,
                  ),
                ),
              );
              print(result);
            },
            child: Text('Push'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            child: Text('Maybe Pop'),
          ),
          ElevatedButton(
            onPressed: () {
              print(Navigator.of(context).canPop());
            },
            child: Text('Can Pop'),
          ),
        ],
      ),
    );
  }
}
