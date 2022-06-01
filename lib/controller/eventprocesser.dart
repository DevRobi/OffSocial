import 'dart:convert';
import 'package:usage_stats/usage_stats.dart';
import 'form_controller.dart';
import '../model/form.dart';
import 'package_names.dart' as globals;

const List<int> openevents = [1, 19];
const List<int> closeevents = [2, 23, 20];

List<EventUsageInfo> convertfromservermap(Map servermap) {
  List<EventUsageInfo> eventUsageInfoList = [];
  servermap.forEach((key, value) {
    EventUsageInfo eventUsageInfo = EventUsageInfo(
        timeStamp: key,
        packageName: value["packagename"],
        eventType: value["eventtype"]);
    eventUsageInfoList.add(eventUsageInfo);
  });
  return eventUsageInfoList;
}

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
  if (closeevents.contains(int.parse(strippedinfolist[0].eventType!))) {
    //dividing by 1000 to get seconds from milliseconds
    totalseconds +=
        ((int.parse(strippedinfolist[0].timeStamp!) - starttime) / 1000)
            .round();
    strippedinfolist.removeAt(0);
  }
  //if the last event is an open event, we need to add the time from the end of the session
  if (strippedinfolist.isEmpty) {
    return totalseconds;
  }
  if (openevents.contains(
      int.parse(strippedinfolist[strippedinfolist.length - 1].eventType!))) {
    //dividing by 1000 to get seconds from milliseconds
    totalseconds += ((endtime -
                int.parse(
                    strippedinfolist[strippedinfolist.length - 1].timeStamp!)) /
            1000)
        .round();
    strippedinfolist.removeAt(strippedinfolist.length - 1);
  }
  if (strippedinfolist.isEmpty) {
    return totalseconds;
  }
  // now we have a list starting with an open event and ending with a close event, and of even length
  // we need to add the time between the events
  for (int i = 0; i < strippedinfolist.length; i += 1) {
    if (openevents.contains(int.parse(strippedinfolist[i].eventType!))) {
      //finding the next close event
      for (int j = i + 1; j < strippedinfolist.length; j += 1) {
        if (closeevents.contains(int.parse(strippedinfolist[j].eventType!))) {
          //dividing by 1000 to get seconds from milliseconds
          totalseconds += ((int.parse(strippedinfolist[j].timeStamp!) -
                      int.parse(strippedinfolist[i].timeStamp!)) /
                  1000)
              .round();
          i = j;
          break;
        }
      }
    }
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
void sendDataToServer(
    Map json, Map rawjson, String deviceid, int dayindex, int allowance) {
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
      ((-totalseconds / 60).round()).toString(),
      facebook.toString(),
      instagram.toString(),
      pinterest.toString(),
      reddit.toString(),
      tiktok.toString(),
      tumblr.toString(),
      twitch.toString(),
      twitter.toString(),
      youtube.toString(),
      jsonEncode(json) + jsonEncode(rawjson),
      dayindex.toString(),
      DateTime.now().toString(),
      allowance.toString());

  //send to server
  FormController formController = FormController();
  formController.submitForm(feedbackForm, (String response) {
    return;
  });
}

Map createmapfromeventinfolist(List<EventUsageInfo> infolist) {
  Map tobejson = {};
  for (EventUsageInfo info in infolist) {
    tobejson[info.timeStamp!] = {};
    tobejson[info.timeStamp!]["eventtype"] = info.eventType;
    tobejson[info.timeStamp!]["packagename"] = info.packageName;
  }
  return tobejson;
}

void eventprocesser(String deviceid, List<EventUsageInfo> infolist,
    DateTime startdate, DateTime enddate) async {
  //split data to days
  //it will be a map with the day as key and the list of events as value
  var splitintodays = {};
  // day 0 is the first day of the session
  // day are indexed from epoch (0 is 1 January, 1970)
  // if all the events will be counted on this day, day0 goes to the next day
  String day0 =
      dayindexfromtimestamp(int.parse(infolist[0].timeStamp!)).toString();
  List<EventUsageInfo> emptylist = [];
  splitintodays[day0] = emptylist;
  for (var info in infolist) {
    // we only need open and close events
    int eventtype = int.parse(info.eventType!);
    if (openevents.contains(eventtype) || closeevents.contains(eventtype)) {
      //get dayindex
      String day = dayindexfromtimestamp(int.parse(info.timeStamp!)).toString();
      if (day != day0) {
        if (splitintodays.containsKey(day) != true) {
          emptylist = [];
          splitintodays[day] = emptylist;
        }
      }
      splitintodays[day].add(info);
    }
  }
  // we send all the data to the server, day by day
  for (var day in splitintodays.keys) {
    // if it is on the same day as sending, the end of request is now
    if (day0 == day && splitintodays.keys.length == 1) {
      sendDataToServer(
          createjsonofusage(splitintodays[day],
              startdate.millisecondsSinceEpoch, enddate.millisecondsSinceEpoch),
          createmapfromeventinfolist(splitintodays[day]),
          deviceid,
          int.parse(day),
          0);
    } else if (day0 == day) {
      sendDataToServer(
          createjsonofusage(
              splitintodays[day],
              startdate.millisecondsSinceEpoch,
              int.parse(day) * 86400000 + 86400000),
          createmapfromeventinfolist(infolist),
          deviceid,
          int.parse(day),
          0);
      //if we are sending the data not for the current day, the request period is that whole day
    } else if (day ==
        dayindexfromtimestamp(
                int.parse(infolist[infolist.length - 1].timeStamp!))
            .toString()) {
      sendDataToServer(
          createjsonofusage(splitintodays[day], int.parse(day) * 86400000,
              enddate.millisecondsSinceEpoch),
          createmapfromeventinfolist(infolist),
          deviceid,
          int.parse(day),
          0);
    } else {
      sendDataToServer(
          createjsonofusage(splitintodays[day], int.parse(day) * 86400000,
              int.parse(day) * 86400000 + 86400000),
          createmapfromeventinfolist(infolist),
          deviceid,
          int.parse(day),
          0);
    }
  }
}
