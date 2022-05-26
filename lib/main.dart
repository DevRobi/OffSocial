// ignore_for_file: unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, unused_import
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:tracker/controller/form_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';

import 'interface/pages.dart';
import 'controller/eventprocesser.dart';

List<String> entries = [];

// Get request on the server
Future<List> FetchUserData() async {
  FormController formController = FormController();
  List list = await formController.GetUserData();
  return list;
}

// Sorting users
Future<List> SortUsers(Future<List> jsondata) async {
  List list = await jsondata;

  List<int> scores = [];
  for (Map map in list) {
    Map newmap = Map.from(map);
    if (newmap['score'].runtimeType == int) {
      scores.add((newmap)['score']);
    }
  }

  scores.sort();
  List<int> final_scores = scores.reversed.toList();
  List<String> device_ids = [];
  for (int score in final_scores) {
    for (Map map in list) {
      Map newmap = Map.from(map);

      if (newmap['score'] == score &&
          device_ids.contains(newmap['deviceId']) == false) {
        device_ids.add(newmap['deviceId']);
      }
    }
  }
  for (String s in device_ids) {
    entries.add(s);
  }
  print(device_ids);
  List<List> final_list = [];
  final_list.add(device_ids);
  final_list.add(final_scores);

  return final_list;
  // add these values to a GUI List element --> order the names --> leaderboard.
}

Future<int> getCurrentScore(Future<List> lists, String? deviceId) async {
  List Lists = await lists;
  List device_ids = Lists[0];
  List scores = Lists[1];
  for (int i = 0; i < device_ids.length; i++) {
    if (device_ids[i] == deviceId) return scores[i];
  }
  return 0;
}

Future<List> getList() {
  return Future.value([1, 2, 3, 4]);
}

void addItem() {
  List list = [];
  print(list);
}

void main() {
  runApp(MaterialApp(home: MyApp()));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    UsageStats.grantUsagePermission();
    String deviceid =
        await PlatformDeviceId.getDeviceId ?? "Failed to get deviceid";
    print(deviceid);
    final prefs = await SharedPreferences.getInstance();
    //get start time
    DateTime start = DateTime.parse(prefs.getString('lastupdated') ??
        DateTime.now().subtract(Duration(hours: 1)).toString());
    //write updated time
    DateTime end = DateTime.now();
    prefs.setString('lastupdated', end.toString());
    List<EventUsageInfo> infolist = await UsageStats.queryEvents(start, end);
    eventprocesser(deviceid, infolist, start, end);
    //it needs max 45 seconds to finish
    await Future.delayed(Duration(seconds: 45));
    print("background task executed");
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pageContoller = PageController(initialPage: 1);
  // stlying of the bottom bar
  final TabStyle _tabStyle = TabStyle.fixed;
  int _status = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print('initplatformstate ran');
    UsageStats.grantUsagePermission();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    Workmanager().registerPeriodicTask(
        "send data to server", "simplePeriodicTask",
        frequency: Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.connected));
    /*Workmanager().registerOneOffTask('sending data to server', "simpleOneOff",
        constraints: Constraints(networkType: NetworkType.connected));*/
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageViewDemo(),
    );
  }
}
