import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:tracker/model/counter.dart';
import 'package:tracker/interface/page_constructor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';

import 'controller/eventprocesser.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print("[BackgroundFetch] Headless event received: $taskId");
  BackgroundFetch.finish(taskId);
}

void main() async {
  runApp(const MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    configBackgroundFetch();
  }

  void _onBackgroundFetch(String taskId) async {
    try {
      print("[BackgroundFetch] Event received: $taskId");
      UsageStats.grantUsagePermission();
      String deviceid =
          await PlatformDeviceId.getDeviceId ?? "Failed to get deviceid";
      print("[BackgroundFetch] deviceid: $deviceid");
      final prefs = await SharedPreferences.getInstance();
      print(prefs.toString());
      //get start time
      DateTime start = DateTime.parse(prefs.getString('lastupdated') ??
          DateTime.now().subtract(const Duration(days: 7)).toString());
      //write updated time
      DateTime end = DateTime.now();
      prefs.setString('lastupdated', end.toString());

      print("[BackgroundFetch] lastupdated: $start.toString()");
      List<EventUsageInfo> infolist = await UsageStats.queryEvents(start, end);

      createUsageMap(
          infolist, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch);

      List<int> listofresponses =
          await eventprocesser(deviceid, infolist, start, end);
      print("[BackgroundFetch] listofresponses: $listofresponses");
      BackgroundFetch.finish(taskId);
    } catch (e) {
      print('[BackgroundFetch] Failed to complete fetch: $e');
      BackgroundFetch.finish(taskId);
    }
  }

  void _onBackgroundFetchTimeout(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void configBackgroundFetch() async {
    int backgroundFetchConfigureStatus = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
          requiredNetworkType: NetworkType.ANY,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout);
    print("backgroundfetchocnfig status : " +
        backgroundFetchConfigureStatus.toString());

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PageIndexProviderModel(),
        child: MaterialApp(
            home: PageViewDemo(),
            theme: ThemeData(
              secondaryHeaderColor: Colors.green,
              primaryColor: Colors.green,
              primarySwatch: Colors.green,
              fontFamily: 'Roboto',
            )));
  }
}
