// ignore_for_file: unused_import, unused_element, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print
import 'package:flutter/cupertino.dart';
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
// szia helo alljunk osszi mint ket kicsi lego
// szia helo alljunk osszi mint ket kicsi lego
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
  //init device ID
  String? _deviceId;
  // stlying of the bottom bar
  final TabStyle _tabStyle = TabStyle.fixed;
  get floatingActionButton => null;

  // array of socials
  static const appnamearray = [
    "com.discord",
    "com.facebook.katana",
    "com.facebook.orca",
    "com.vanced.android.youtube",
    "com.google.android.youtube",
    "com.ss.android.ugc.trill",
    "com.instagram.android",
    "com.twitter.android",
    "com.snapchat",
    "com.zhiliaoapp.musically",
    "com.reddit.frontpage"
  ];

  // scoring variables

  int _usageseconds = 0;
  int _numpressed = 0;
  var currentScore;
  var defaultScore = 120;
  double roundedScore = 0;
  get displayedScore => null;

  @override
  void initState() {
    super.initState();
  }

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
      print("deviceId->$_deviceId");
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0);
      List<AppUsageInfo> infoList =
          await AppUsage.getAppUsage(startDate, endDate);
      var inseconds = 0;
      for (var info in infoList) {
        if (appnamearray.contains(info.packageName)) {
          inseconds += info.usage.inSeconds;
        }
      }
      setState(() {
        _usageseconds = inseconds;
        _numpressed++;

        // scoring function
        currentScore = (defaultScore - (_usageseconds / 60));

        // rounding the score value
        double locRoundedScore = currentScore;
        currentScore = locRoundedScore.round();

        // ignore: unused_local_variable
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  void _submitForm() {
    FeedbackForm feedbackForm =
        FeedbackForm(_deviceId!, 'V1.0', _usageseconds.toString());

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
                  getUsageStats();
                  _submitForm();
                  initPlatformState();
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
