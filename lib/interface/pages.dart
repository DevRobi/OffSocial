// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, unused_import, unused_field, avoid_print
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:tracker/controller/form_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker/model/counter.dart';
import 'package:usage_stats/usage_stats.dart';
import '../controller/form_controller.dart';

import 'dart:async';
import 'dart:io';

import '../controller/eventprocesser.dart';
import '../../main.dart';
import '../../images/images.dart';
import 'package:charts_painter/chart.dart';
import 'package:provider/provider.dart';

/// ADDIIONAL WIDGETS (will be in a separate file in future)
/// PageViewDemo (Main SubWidget) begin ///
// The Main Page (SubWidget of PageViewDemo)

/*class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  int _selectedIndex = 1;

  final PageController _controller = PageController(
    initialPage: 1,
    viewportFraction: 0.99,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom navigator bar
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        type: BottomNavigationBarType.shifting,
        selectedFontSize: 20,
        selectedIconTheme:
            IconThemeData(color: Color.fromARGB(218, 52, 51, 51)),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: IconThemeData(
          color: Colors.deepOrangeAccent,
        ),
        selectedItemColor: Color.fromARGB(255, 64, 156, 255),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_rounded),
            label: '-',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: '-',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: '-',
          )
        ],
        onTap: (int index) {
          _controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        currentIndex: _selectedIndex,
      ),

      // The 3 main pages (pageview)
      body: PageView(
        controller: _controller,
        children: <Widget>[
          StatisticsPage(),
          LeaderboardPage(),
          FriendsPage(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }
}*/

class MyBottomNavigationBar extends StatelessWidget {
  @override
  const MyBottomNavigationBar({
    Key? key,
    required this.onTapped,
    required this.pageController,
  }) : super(key: key);
  final void Function(int)? onTapped;
  final PageController pageController;

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 30,
      type: BottomNavigationBarType.shifting,
      selectedFontSize: 20,
      selectedIconTheme: IconThemeData(color: Color.fromARGB(218, 52, 51, 51)),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedIconTheme: IconThemeData(
        color: Colors.deepOrangeAccent,
      ),
      selectedItemColor: Color.fromARGB(255, 64, 156, 255),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'szeklet'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'urulek'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'trotty'),
      ],
      onTap: onTapped,
      currentIndex: Provider.of<PageIndexProviderModel>(context).pageNumber,
    );
  }
}

class PageViewDemo extends StatelessWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 1);
    void _onTappedBar(int value) {
      Provider.of<PageIndexProviderModel>(context, listen: false)
          .setPage(value);
      _pageController.animateToPage(value,
          duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
    }

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          pageController: _pageController, onTapped: _onTappedBar),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onTappedBar,
        children: [StatisticsPage(), LeaderboardPage(), FriendsPage()],
      ),
    );
  }
}

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Map leaderboardvalues = {"couldn't load your friends' points": ""};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: leaderboardvalues.length, //length of players list
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
                      leaderboardvalues.keys.toList()[index].toString() +
                      " " +
                      leaderboardvalues.values.toList()[index].toString() +
                      " pts",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          );
        });
  }
}

// The Page on the Left side (SubWidget of PageViewDemo)
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  String? get deviceId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Your Stats. Now.',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
                decorationColor: Colors.black54,
                decorationStyle: TextDecorationStyle.solid,
                fontFamily: "alex"),
          )),
      body: Center(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Text(
              "Your current score: " + "Loading...",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  decorationColor: Colors.black54,
                  decorationStyle: TextDecorationStyle.solid,
                  fontFamily: "alex"),
            ),
            Text(
              "This weeks' best score: " + "Loading...",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  decorationColor: Colors.black54,
                  decorationStyle: TextDecorationStyle.solid,
                  fontFamily: "alex"),
            ),
            Chart<void>(
              height: 600.0,
              state: ChartState(
                ChartData.fromList(
                  [1, 3, 4, 2, 7, 6, 2, 5, 4]
                      .map((e) => BarValue<void>(e.toDouble()))
                      .toList(),
                  axisMax: 8.0,
                ),
                itemOptions: BarItemOptions(
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  radius: BorderRadius.vertical(top: Radius.circular(42.0)),
                ),
                backgroundDecorations: [
                  GridDecoration(
                    verticalAxisStep: 1,
                    horizontalAxisStep: 1,
                  ),
                ],
                foregroundDecorations: [
                  BorderDecoration(
                    borderWidth: 5.0,
                  ),
                ],
                behaviour: ChartBehaviour(
                  isScrollable: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The Main Page (SubWidget of PageViewDemo)
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Leaderboard',
              style: TextStyle(
                color: Color.fromARGB(255, 39, 19, 49),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
                decorationColor: Colors.black54,
              ),
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
                    child: LeaderBoard(),
                  ),
                ],
              )),
        ));
  }
}

// The Page on the Right side (SubWidget of PageViewDemo)
class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Your Friends. Beat them!',
            style: TextStyle(
              color: Color.fromARGB(255, 61, 61, 213),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
          ),
          backgroundColor: Color.fromARGB(255, 23, 23, 24),
        ),
        body: Center(child: Image.asset('assets/qr-code.png')));
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

// just a custom widget, it renders a box with a text inside
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
