// ignore_for_file: unused_import, unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print
import 'dart:typed_data';

import 'package:binary_codec/binary_codec.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:math';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

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

  // array of socials
  static const packagenamearray = [
    "com.discord",
    "com.facebook.katana",
    "com.facebook.orca",
    "com.vanced.android.youtube",
    "com.google.android.youtube",
    "com.ss.android.ugc.trill",
    "com.instagram.android",
    "com.twitter.android",
    "com.zhiliaoapp.musically",
    "com.reddit.frontpage"
  ];
  static const appnamearray = [
    'facebook',
    'instagram',
    'pinterest',
    'reddit',
    'tiktok',
    'tumblr',
    'twitch',
    'twitter',
    'youtube'
  ];

  // scoring variables
  int _defaultscore = 120;
  int _score = 0;

  int _facebook = 0;
  int _instagram = 0;
  int _pinterest = 0;
  int _reddit = 0;
  int _tiktok = 0;
  int _tumblr = 0;
  int _twitch = 0;
  int _twitter = 0;
  int _youtube = 0;

  String _encodedinfo = "";

  String? _deviceId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
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

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0);
      List<AppUsageInfo> infoList =
          await AppUsage.getAppUsage(startDate, endDate);
      var inseconds = 0;
      var tobejson = {};
      for (var info in infoList) {
        tobejson[info.appName] = {
          'usage': info.usage.inSeconds,
          'packageName': info.packageName,
        };
        if (packagenamearray.contains(info.packageName)) {
          inseconds += info.usage.inSeconds;
          switch ((info.appName).toLowerCase().split(' ')[0]) {
            case 'facebook':
              {
                _facebook = info.usage.inSeconds;
              }
              break;
            case 'instagram':
              {
                _instagram = info.usage.inSeconds;
              }
              break;
            case 'pinterest':
              {
                _pinterest = info.usage.inSeconds;
              }
              break;
            case 'reddit':
              {
                _reddit = info.usage.inSeconds;
              }
              break;
            case 'tiktok':
              {
                _tiktok = info.usage.inSeconds;
              }
              break;
            case 'tumblr':
              {
                _tumblr = info.usage.inSeconds;
              }
              break;
            case 'twitter':
              {
                _twitter = info.usage.inSeconds;
              }
              break;
            case 'twitch':
              {
                _twitch = info.usage.inSeconds;
              }
              break;
            case 'youtube':
              {
                _youtube = info.usage.inSeconds;
              }
              break;
          }
        }
      }
      setState(() {
        // scoring function
        _score = (_defaultscore - (inseconds / 60)).round();
        // encoding function
        _encodedinfo = jsonEncode(tobejson);
        print(tobejson);
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  void _submitForm() {
    FeedbackForm feedbackForm = FeedbackForm(
        _deviceId!,
        'V1.1',
        _score.toString(),
        _facebook.toString(),
        _instagram.toString(),
        _pinterest.toString(),
        _reddit.toString(),
        _tiktok.toString(),
        _tumblr.toString(),
        _twitch.toString(),
        _twitter.toString(),
        _youtube.toString(),
        _encodedinfo,
        DateTime.now().toString());

    FormController formController = FormController();

    // Submit 'feedbackForm' and save it in Google Sheets.
    formController.submitForm(feedbackForm, (String response) {
      print("Response: $response");
      if (response == FormController.STATUS_SUCCESS) {
        // Feedback is saved succesfully in Google Sheets.
        print("Submitted");
      } else {
        // Error Occurred while saving data in Google Sheets.
        print("Error Occurred!");
      }
    });
  }

  void getDeviceIDUsingPlugin() {
    String? deviceId;
    deviceId = PlatformDeviceId.getDeviceId as String?;
    print(deviceId);
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
                  _submitForm();
                  getUsageStats();
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
