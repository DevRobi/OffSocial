// ignore_for_file: unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, unused_import
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:tracker/controller/form_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'interface/pages.dart';
import 'controller/eventprocesser.dart';
import 'package:tracker/model/counter.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() {
  runApp(MyApp());
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
        DateTime.now().subtract(Duration(days: 7)).toString());
    //write updated time
    DateTime end = DateTime.now();
    prefs.setString('lastupdated', end.toString());
    List<EventUsageInfo> infolist = await UsageStats.queryEvents(start, end);
    eventprocesser(deviceid, infolist, start, end);
    //it needs max 45 seconds to finish
    await Future.delayed(Duration(seconds: 32));
    print("background task executed");
    return Future.value(true);
  });
}

void setHighRefreshRate() async {
  await FlutterDisplayMode.setHighRefreshRate();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PageIndexProviderModel(),
        child: MaterialApp(home: PageViewDemo()));
  }
}
