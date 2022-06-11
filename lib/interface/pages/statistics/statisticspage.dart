// ignore_for_file: prefer_const_constructors, unnecessary_import, unused_import

import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/controller/getlocaldata.dart';
import 'package:intl/intl.dart';
import 'package:clock/clock.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/core_internal.dart';
import 'package:syncfusion_flutter_core/interactive_scroll_viewer_internal.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/tooltip_internal.dart';
import 'package:syncfusion_flutter_core/zoomable_internal.dart';
import 'package:tracker/interface/pages/statistics/bar_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with AutomaticKeepAliveClientMixin {
  String? get deviceId => null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text(
            'Statistics',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
                decorationColor: Colors.black54,
                decorationStyle: TextDecorationStyle.solid,
                fontFamily: "alex"),
          )),
      body: BarChart(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
