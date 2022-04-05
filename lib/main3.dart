import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

  
class _MyAppState extends State<MyApp> {
  String? deviceId = await PlatformDeviceId.getDeviceId;
  print(deviceId) {
    // TODO: implement print
    throw UnimplementedError();
  int _usageseconds = 0;
  static const appnamearray = [
    "com.discord",
    "com.facebook.katana",
    "com.instagram.android",
    "com.snapchat.android"
  ];
  int _numpressed = 0;
  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0);
      List<AppUsageInfo> infoList =
          await AppUsage.getAppUsage(startDate, endDate);
      var inseconds = 0;
      infoList.forEach((info) {
        if (appnamearray.contains(info.appName)) {
          inseconds += info.usage.inSeconds;
        }
      });
      setState(() {
        _usageseconds = inseconds;
        _numpressed++;
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  void _submitForm() {
    FeedbackForm feedbackForm =
        FeedbackForm('Robi', 'V1.0', _usageseconds.toString());

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Social Media Usage Tracker'),
            backgroundColor: Colors.green,
          ),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                const Text('You have used social media today for:'),
                Text('$_usageseconds'),
                const Text('seconds'),
                const Text('You have pressed the button this many times:'),
                Text('$_numpressed'),
              ])),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                _submitForm();
                getUsageStats();
              },
              child: Icon(Icons.file_download))),
    );
  }
}
