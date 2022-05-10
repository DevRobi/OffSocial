// ignore_for_file: unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:tracker/controller/form_controller.dart';
import 'dart:async';
import '../eventprocesser.dart';
import 'package:f_logs/f_logs.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

// defining separated pages
const _kPages = <String, IconData>{
  'Profile': Icons.account_circle,
  'Home': Icons.house_sharp,
  'Stats': Icons.graphic_eq_outlined,
};

List<String> entries = [];
//Get request on the server
Future<List> FetchUserData() async {
  FormController formController = FormController();
  List list = await formController.GetUserData();
  return list;
}

//Sorting users
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
  //add these values to a GUI List element --> order the names --> leaderboard.
}

Future<List> getList() {
  return Future.value([1, 2, 3, 4]);
}

void addItem() {
  List list = [];
  print(list);
}

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

void main() {
  runApp(MaterialApp(home: MyApp()));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pageContoller = PageController(initialPage: 0);
  // stlying of the bottom bar
  final TabStyle _tabStyle = TabStyle.fixed;
  get floatingActionButton => null;

  String? _deviceId;
  int _status = 0;

  @override
  void initState() {
    super.initState();
    SortUsers(FetchUserData());
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
    UsageStats.grantUsagePermission();
    //init logger
    FLog.applyConfigurations(FLog.getDefaultConfigurations());
    //background fetch
    try {
      var status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
              minimumFetchInterval: 5,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY),
          _onBackgroundFetch,
          _onBackgroundFetchTimeout);
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        _status = status;
      });
    } on Exception catch (e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }

    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (err) {
      deviceId = 'Failed to get deviceId.';
      FLog.error(
          className: "MyApp",
          methodName: "initPlatformState",
          text: err.toString());
    }

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    String deviceid =
        await PlatformDeviceId.getDeviceId ?? "Failed to get deviceid";
    eventprocesser(deviceid);
    print('\n\ndone\n\n');
    BackgroundFetch.finish(taskId);
  }

  /// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

/*
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        body: Column(
          children: [
            const Divider(),
            FloatingActionButton(
                onPressed: () {
                  initPlatformState();
                  SortUsers(FetchUserData());
                  eventprocesser(_deviceId!);
                },
                child: const Icon(Icons.refresh)),
            Expanded(
              child: TabBarView(
                children: [
                  for (final icon in _kPages.values) Icon(icon, size: 64),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: _tabStyle,
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
          onTap: (int i) => print('click index=$i'),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pageview Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: PageView(
        pageSnapping: true,
        controller: pageContoller,
        children: [
          Container(
              color: Colors.white10,
              alignment: Alignment.center,
              //FutureBuilder
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: Text("Your Stats. Now.",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black54,
                              decorationStyle: TextDecorationStyle.solid,
                              fontFamily: "alex"))),
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
                            return const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment(-0.5, -0.6),
                                  radius: 0.15,
                                  colors: <Color>[
                                    Color(0xFFEEEEEE),
                                    Color(0xFF111133),
                                  ],
                                  stops: <double>[0.9, 1.0],
                                ),
                              ),
                              
                              child: Text("Your current score is: "),
                            );
                          }
                        }),
                  ),
                ],
              )),
          Container(
              color: Colors.white10,
              alignment: Alignment.center,
              //FutureBuilder
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: Text("Weekly Leaderboard",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                              decorationColor: Colors.black54,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontFamily: "alex"))),
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
              )),
          Container(
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
}
