// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

/// ADDIIONAL WIDGETS (will be in a separate file in future)
  /// PageViewDemo (Main SubWidget) begin /// 
class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {

  final PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        MyPageLeftWidget(),  // The Page on the left
        MyPageMainWidget(),  // Main Page
        MyPageRightWidget(), // The Page on the right
      ],
    );
  }
}
  /// PageViewDemo (Main SubWidget) end  ///

// The Main Page (SubWidget of PageViewDemo)
class MyPageMainWidget extends StatelessWidget {
  const MyPageMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkGreen, height: 50, text: 'Leaderboard', textSize: 7),
          ],
        ),
        Row(
          children: [
            MyBox(lightGreen, height: 15, text: 'UserID',),
            MyBox(lightGreen, height: 15, text: 'Score',),
          ],
        ),
        MyBox(mediumGreen, text: '', height: 15,),
        
      ],
    );
  }
}

// The Page on the Left side (SubWidget of PageViewDemo)
class MyPageLeftWidget extends StatelessWidget {
  const MyPageLeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkBlue, height: 50, text: '',),
            MyBox(darkBlue, height: 50, text: '',),
          ],
        ),
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            MyBox(lightBlue, height: 10, text: '',),
            MyBox(lightBlue, height: 10, text: '',),
          ],
        ),
        MyBox(mediumBlue, text: 'Unknown', height: 10,),
        Row(
          children: [
            MyBox(lightBlue, height: 10, text: '',),
            MyBox(lightBlue, height: 10, text: '',),
          ],
        ),
      ],
    );
  }
}

// The Page on the Right side (SubWidget of PageViewDemo)
class MyPageRightWidget extends StatelessWidget {
  const MyPageRightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkRed, height: 10, text: '',),
            MyBox(darkRed, height: 10, text: '',),
          ],
        ),
        MyBox(mediumRed, text: 'My Stats', height: 10,),
        Row(
          children: [
            MyBox(lightRed, height: 10, text: '',),
            MyBox(lightRed, height: 10, text: '',),
            MyBox(lightRed, height: 10, text: '',),
          ],
        ),
      ],
    );
  }
}


// this is just styling the custom MyBox widget (from a dumb video..., not necessary)
const lightBlue = Color(0xff00bbff);
const mediumBlue = Color(0xff00a2fc);
const darkBlue = Color(0xff0075c9);

final lightGreen = Colors.green.shade300;
final mediumGreen = Colors.green.shade600;
final darkGreen = Colors.green.shade900;

final lightRed = Colors.red.shade300;
final mediumRed = Colors.red.shade600;
final darkRed = Colors.red.shade900;


class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  const MyBox(this.color, {required this.height, required this.text, textSize});

  @override
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        color: color,
        // ignore: unnecessary_null_comparison
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}