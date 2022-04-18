// TO DO

//check why timezones automagically work

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'package_names.dart' as globals;

//event types 1 : open 2 : close

int dayindexfromtimestamp(int timestamp) {
  //there are 86400000 milliseconds in a day
  return (timestamp / 86400000).floor();
}

int processtimeforpackagename(String packagename, List<EventUsageInfo> infolist,
    int starttime, int endtime) {
  //we only need the list with the wanted package name
  int totalseconds = 0;
  List<EventUsageInfo> strippedinfolist = [];
  for (EventUsageInfo info in infolist) {
    if (info.packageName == packagename) {
      strippedinfolist.add(info);
    }
  }
  //empty list => no usage
  if (strippedinfolist.isEmpty) {
    return 0;
  }
  // if the first event is a close event, we need to add the time from the start of the session
  if (int.parse(strippedinfolist[0].eventType!) == 2) {
    //dividing by 1000 to get seconds from milliseconds
    totalseconds +=
        ((int.parse(strippedinfolist[0].timeStamp!) - starttime) / 1000)
            .round();
    strippedinfolist.removeAt(0);
  }
  //if the last event is an open event, we need to add the time from the end of the session
  if (int.parse(strippedinfolist[strippedinfolist.length - 1].eventType!) ==
      1) {
    //dividing by 1000 to get seconds from milliseconds
    totalseconds += ((endtime -
                int.parse(
                    strippedinfolist[strippedinfolist.length - 1].timeStamp!)) /
            1000)
        .round();
    strippedinfolist.removeAt(strippedinfolist.length - 1);
  }
  // now we have a list starting with an open event and ending with a close event, and of even length
  // we need to add the time between the events
  for (int i = 0; i < strippedinfolist.length - 1; i += 2) {
    totalseconds += (int.parse(strippedinfolist[i + 1].timeStamp!) -
            int.parse(strippedinfolist[i].timeStamp!)) ~/
        1000;
  }
  return totalseconds;
}

Map createjsonofusage(
    List<EventUsageInfo> infolist, int starttime, int endtime) {
  Map tobejson = {};
  //creating a list of all package names
  List<String> packagenamelist = [];
  for (EventUsageInfo info in infolist) {
    if (!packagenamelist.contains(info.packageName)) {
      packagenamelist.add(info.packageName!);
    }
  }
  // now we will map the package names to the time they were used
  for (String packagename in packagenamelist) {
    tobejson[packagename] =
        processtimeforpackagename(packagename, infolist, starttime, endtime);
  }
  return tobejson;
}

//for this function, error codes are: 0 succes 1
void sendDataToServer(Map json, String deviceid, int dayindex) {
  //extract tracked apps from json

  // declare tracking variables
  int totalseconds = 0;
  int facebook = 0;
  int instagram = 0;
  int pinterest = 0;
  int reddit = 0;
  int tiktok = 0;
  int tumblr = 0;
  int twitch = 0;
  int twitter = 0;
  int youtube = 0;

  //iterate over json
  for (var packagename in json.keys) {
    int inseconds = json[packagename];
    if (globals.allPackageNames.contains(packagename)) {
      totalseconds += inseconds;
    }
    if (globals.facebookPackageNames.contains(packagename)) {
      facebook += inseconds;
    }
    if (globals.instagramPackageNames.contains(packagename)) {
      instagram += inseconds;
    }
    if (globals.pinterestPackageNames.contains(packagename)) {
      pinterest += inseconds;
    }
    if (globals.redditPackageNames.contains(packagename)) {
      reddit += inseconds;
    }
    if (globals.tiktokPackageNames.contains(packagename)) {
      tiktok += inseconds;
    }
    if (globals.tumblrPackageNames.contains(packagename)) {
      tumblr += inseconds;
    }
    if (globals.twitchPackageNames.contains(packagename)) {
      twitch += inseconds;
    }
    if (globals.twitterPackageNames.contains(packagename)) {
      twitter += inseconds;
    }
    if (globals.youtubePackageNames.contains(packagename)) {
      youtube += inseconds;
    }
  }

  //create form
  FeedbackForm feedbackForm = FeedbackForm(
      deviceid,
      "V2.0",
      ((totalseconds / 60).round()).toString(),
      facebook.toString(),
      instagram.toString(),
      pinterest.toString(),
      reddit.toString(),
      tiktok.toString(),
      tumblr.toString(),
      twitch.toString(),
      twitter.toString(),
      youtube.toString(),
      jsonEncode(json),
      dayindex.toString(),
      DateTime.now().toString());

  //send to server
  FormController formController = FormController();

  formController.submitForm(feedbackForm, (String response) {
    return;
  });
}

void eventprocesser(String deviceid) async {
  //get shared prefs
  final prefs = await SharedPreferences.getInstance();
  //get start time
  DateTime lastupdated = DateTime.parse(
      prefs.getString('lastupdated') ?? DateTime.now().toString());
  //write updated time
  DateTime end = DateTime.now();
  prefs.setString('lastupdated', end.toString());

  //getting infos
  List<EventUsageInfo> infolist = await UsageStats.queryEvents(
      lastupdated.add(Duration(milliseconds: 1)), end);
  if (infolist.isEmpty) {
    return;
  }
  //split data to days
  //it will be a map with the day as key and the list of events as value
  var splitintodays = {};
  // day 0 is the first day of the session
  // day are indexed from epoch (0 is 1 January, 1970)
  // if all the events will be counted on this day, day0 goes to the next day
  String day0 =
      dayindexfromtimestamp(int.parse(infolist[0].timeStamp!)).toString();
  String tempday0 = day0;
  List<EventUsageInfo> emptylist = [];
  splitintodays[day0] = emptylist;
  for (var info in infolist) {
    // we only need open and close events
    if (int.parse(info.eventType!) == 1 || int.parse(info.eventType!) == 2) {
      String day = dayindexfromtimestamp(int.parse(info.timeStamp!)).toString();
      if (day == day0) {
        splitintodays[day0].add(info);
      } else {
        splitintodays[day] = emptylist;
        splitintodays[day].add(info);
        day0 = day;
      }
    }
  }
  // we send all the data to the server, day by day
  for (var day in splitintodays.keys) {
    // if it is on the same day as sending, the end of request is now
    if (tempday0 == day0) {
      sendDataToServer(
          createjsonofusage(splitintodays[day],
              lastupdated.millisecondsSinceEpoch, end.millisecondsSinceEpoch),
          deviceid,
          int.parse(day));
    } else if (tempday0 == day) {
      sendDataToServer(
          createjsonofusage(
              splitintodays[day],
              lastupdated.millisecondsSinceEpoch,
              int.parse(day) * 86400000 + 86400000),
          deviceid,
          int.parse(day));
      //if we are sending the data not for the current day, the request period is that whole day
    } else if (day == day0) {
      sendDataToServer(
          createjsonofusage(splitintodays[day], int.parse(day) * 86400000,
              end.millisecondsSinceEpoch),
          deviceid,
          int.parse(day));
    } else {
      sendDataToServer(
          createjsonofusage(splitintodays[day], int.parse(day) * 86400000,
              int.parse(day) * 86400000 + 86400000),
          deviceid,
          int.parse(day));
    }
  }
}