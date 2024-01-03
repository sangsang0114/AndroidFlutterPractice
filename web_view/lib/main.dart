import 'package:flutter/material.dart';
import 'package:web_view/screen/home_screen.dart';

void main() {
  //Flutter 프레임워크가 실행할 준비가 될 때까지 기다린다.
  //원래는 runApp 실행 시 자동으로 실행되지만
  //webview controller를 stless widget에서 사용하므로 직접 실행해줘야 함
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
