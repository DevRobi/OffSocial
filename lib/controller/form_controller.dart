import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

import 'package:f_logs/f_logs.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  // ignore: constant_identifier_names
  var URL = Uri.parse(
      "https://script.google.com/macros/s/AKfycbxbBAkdQ0uBo_B9_2NvHw25qPiCcn10vC61hjPfVZmILCkRFB-fX25yfTdRv9e4JpPC/exec");

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  ///

  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    //logfile init
    LogsConfig config = FLog.getDefaultConfigurations();
    FLog.applyConfigurations(config);
    try {
      print(feedbackForm.toJson());
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = Uri.parse(response.headers['location'].toString());
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      FLog.error(
          className: "Formcontroller",
          methodName: "submitform",
          text: e.toString());
    }
  }

  //fetch user data from server
  Future<List> GetUserData() async {
    try {
      final response = await http.get(URL);
      final jsonData = convert.jsonDecode(response.body) as List;
      return jsonData;
    } catch (err) {
      return ["null"];
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<FeedbackForm>> getFeedbackList() async {
    return await http.get(URL).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
    });
  }
}
