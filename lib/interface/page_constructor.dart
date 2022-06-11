// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, unused_import, unused_field, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:provider/provider.dart';
//import 'package:workmanager/workmanager.dart';
import '../../main.dart';
import 'pages/bottom_navigator.dart';
import 'pages/leaderboard/leaderboardpage.dart';
import 'pages/friends/friendspage.dart';
import 'pages/statistics/statisticspage.dart';
import '../../model/counter.dart';
import '../../controller/callbackdispatcher.dart';
import 'package:background_fetch/background_fetch.dart';
import '../../controller/eventprocesser.dart';

void setHighRefreshRate() async {
  await FlutterDisplayMode.setHighRefreshRate();
}

class PageViewDemo extends StatelessWidget {
  PageViewDemo({Key? key}) : super(key: key) {
    initPlatformState();
  }
  void initPlatformState() async {
    print('initplatformstate ran');
    setHighRefreshRate();
    UsageStats.grantUsagePermission();
    /*Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    Workmanager().registerPeriodicTask(
        "send data to server", "simplePeriodicTask",
        frequency: Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected));
    Workmanager().registerOneOffTask('sending data to server', "simpleOneOff",
        constraints: Constraints(networkType: NetworkType.connected));*/
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 1);
    void _onTappedBar(int value) {
      Provider.of<PageIndexProviderModel>(context, listen: false)
          .setPage(value);
      _pageController.animateToPage(value,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }

    void _onPageChanged(int page) {
      Provider.of<PageIndexProviderModel>(context, listen: false).setPage(page);
    }

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          pageController: _pageController, onTapped: _onTappedBar),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          const StatisticsPage(),
          const LeaderboardPage(),
          const FriendsPage()
        ],
      ),
    );
  }
}
