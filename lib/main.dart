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

Future<List> _getUsageData() async {
  DateTime now = DateTime.now();
  var daily_scores = [];
  for (int i = 7; i > 0; i--) {
    DateTime startDate = DateTime(now.year, now.month, now.day - i);
    DateTime endDate = DateTime(now.year, now.month, now.day - i + 1);
    List<EventUsageInfo> infolist =
        await UsageStats.queryEvents(startDate, endDate);
    Map map = createUsageMap(infolist, startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch);
    daily_scores.add(map['score']);
  }
  return daily_scores;
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
