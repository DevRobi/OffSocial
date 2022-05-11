// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, unused_import
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:tracker/controller/form_controller.dart';
import 'package:f_logs/f_logs.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

import 'dart:async';
import 'dart:io';

import '../controller/eventprocesser.dart';
import '../../main.dart';
import '../../images/images.dart';

/// ADDIIONAL WIDGETS (will be in a separate file in future)
  /// PageViewDemo (Main SubWidget) begin /// 
// The Main Page (SubWidget of PageViewDemo)
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




// The Page on the Left side (SubWidget of PageViewDemo)
class MyPageLeftWidget extends StatelessWidget {
  const MyPageLeftWidget({Key? key}) : super(key: key);

  String? get deviceId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your Stats. Now.', 
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.overline,
                  decorationColor: Colors.black54,
                  decorationStyle: TextDecorationStyle.solid,
                  fontFamily: "alex"),
        )
      ),
      
      body: Center(
        child: Expanded(
                    flex: 2,
                    child: FutureBuilder<int>(
                        future: getCurrentScore(
                            SortUsers(FetchUserData()), deviceId),
                        builder: (context, future) {
                          if (!future.hasData) {
                            return Container();
                          } else {
                            int? value = future.data;
                            return Column(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Your current score: " +
                                      value.toString(), style: TextStyle(fontSize: 25)),
                                ),
                                Expanded(
                                  child: Text("Your best score: ", style: TextStyle(fontSize: 25)),)
                              ],
                            );
                          }
                        }),
        ),
      )
    );
  }
}

// The Main Page (SubWidget of PageViewDemo)
class MyPageMainWidget extends StatelessWidget {
  const MyPageMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Weekly Leaderboard', 
                  style: TextStyle(color: Color.fromARGB(255, 82, 34, 108)), 
                  textScaleFactor: 1.3),
      ),
      body: Center(
        child: Container(
              color: Colors.white10,
              alignment: Alignment.center,
              //FutureBuilder
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: FutureBuilder<List>(
                        future: SortUsers(FetchUserData()),
                        builder: (context, future) {
                          if (!future.hasData) {
                            return Container();
                          } else {
                            List? list = future.data;
                            print(list?[0]);
                            print(list?[1]);
                            return ListView.builder(
                                itemCount:
                                    list?[0].length, //length of players list
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(20.0),
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {},
                                      title: Text(
                                          (index + 1).toString() +
                                              ". " +
                                              list![0][index].toString() +
                                              " " +
                                              list[1][index].toString() +
                                              " pts",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                ],
              )
            ),
      )
    );
  }
}

// The Page on the Right side (SubWidget of PageViewDemo)
class MyPageRightWidget extends StatelessWidget {
  const MyPageRightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your Friends. Beat them!', 
              style: TextStyle(color: Color.fromARGB(255, 61, 61, 213)), 
              textScaleFactor: 1.35),
        backgroundColor: Color.fromARGB(255, 210, 65, 72),
      ),
      body: Center(
        child: FileImageWidget()
      )
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

