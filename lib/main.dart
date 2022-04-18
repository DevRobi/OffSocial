// ignore_for_file: unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print
import 'package_names.dart' as globals;
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import '../eventprocesser.dart';
import 'package:f_logs/f_logs.dart';

// defining separated pages
const _kPages = <String, IconData>{
  'Profile': Icons.account_circle,
  'Home': Icons.house_sharp,
  'Stats': Icons.graphic_eq_outlined,
};

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // stlying of the bottom bar
  final TabStyle _tabStyle = TabStyle.fixed;
  get floatingActionButton => null;

  String? _deviceId;
  DateTime _start = DateTime.now();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //init logger
    FLog.applyConfigurations(FLog.getDefaultConfigurations());
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

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
  }
}
