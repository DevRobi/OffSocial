import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  // ignore: constant_identifier_names
  static var url = Uri.parse(
      "https://script.google.com/macros/s/AKfycbxbBAkdQ0uBo_B9_2NvHw25qPiCcn10vC61hjPfVZmILCkRFB-fX25yfTdRv9e4JpPC/exec");

  // Success Status Message

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [url]. On successful response, [callback] is called.
  ///
  /// -1: function error, otherwise http status codes

  Future<int> submitForm(FeedbackForm feedbackForm) async {
    try {
      print(feedbackForm.toJson());
      int responsevar = 0;
      await http.post(url, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = Uri.parse(response.headers['location'].toString());
          await http.get(url).then((response) {
            responsevar = response.statusCode;
          });
        } else {
          responsevar = response.statusCode;
        }
      });
      return responsevar;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  //fetch user data from server
  Future<Map> getUserData() async {
    try {
      final response = await http.get(url);
      final jsonData =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonData;
    } catch (err) {
      return {'null': 'null'};
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<FeedbackForm>> getFeedbackList() async {
    return await http.get(url).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
    });
  }
}

Future<Map> fetchUserData() async {
  FormController formController = FormController();
  Map leaderboarddata = await formController.getUserData();
  return leaderboarddata;
}
