import 'package:usage_stats/usage_stats.dart';
import 'eventprocesser.dart';

// getting local usage stats from the last 7 days

Future<List<int>> getlocaldata() async {
  DateTime now = DateTime.now();
  List<int> dailyScores = [];
  for (int i = 7; i > 0; i--) {
    DateTime startDate = DateTime(now.year, now.month, now.day - i);
    DateTime endDate = DateTime(now.year, now.month, now.day - i + 1);
    List<EventUsageInfo> infolist =
        await UsageStats.queryEvents(startDate, endDate);
    Map map = createUsageMap(infolist, startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch);
    dailyScores.add(map['score'].round());
  }
  return dailyScores;
}
