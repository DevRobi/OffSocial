import 'package:workmanager/workmanager.dart';
import 'package:usage_stats/usage_stats.dart';
import 'eventprocesser.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    UsageStats.grantUsagePermission();
    String deviceid =
        await PlatformDeviceId.getDeviceId ?? "Failed to get deviceid";
    print(deviceid);
    final prefs = await SharedPreferences.getInstance();
    //get start time
    DateTime start = DateTime.parse(prefs.getString('lastupdated') ??
        DateTime.now().subtract(const Duration(days: 7)).toString());
    //write updated time
    DateTime end = DateTime.now();
    prefs.setString('lastupdated', end.toString());
    List<EventUsageInfo> infolist = await UsageStats.queryEvents(start, end);

    createUsageMap(
        infolist, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch);

    eventprocesser(deviceid, infolist, start, end);
    //it needs max 45 seconds to finish
    await Future.delayed(const Duration(seconds: 32));
    print("background task executed");
    return Future.value(true);
  });
}
