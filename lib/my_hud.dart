import 'package:floatyprince/main.dart';
import 'package:floatyprince/my_engine.dart';
import "package:flutter/material.dart";

var stage =  Stage();

class MyHUD extends StatefulWidget {
  const MyHUD(Key? key):super(key: key);

  @override
  MyHUDState createState() {
    return MyHUDState();
  }
}

class MyHUDState extends State<MyHUD> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    stream.listen((event) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
        ),
    ]);
  }

}