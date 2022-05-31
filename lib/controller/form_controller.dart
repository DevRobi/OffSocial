import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

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
      print(e.toString());
    }
  }

  //fetch user data from server
  Future<Map> GetUserData() async {
    try {
      final response = await http.get(URL);
      final jsonData =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } catch (err) {
      return {'null': 'null'};
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

Future<Map> FetchUserData() async {
  FormController formController = FormController();
  Map leaderboarddata = await formController.GetUserData();
  return leaderboarddata;
}
