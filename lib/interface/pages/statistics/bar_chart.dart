import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import '../../../controller/getlocaldata.dart';
import 'dart:math';

class BarChart extends StatefulWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  double _valuegenerator(ChartItem<dynamic> item) {
    return item.max!;
  }

  String _daynamefromindex(int index) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int currentdayindex = DateTime.now().weekday;
    return days[(currentdayindex + index) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
        children: <Widget>[
          FutureBuilder<List<int>>(
              future: getlocaldata(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('Loading....');
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<int>? scores = snapshot.data;
                      int mininumscore = scores!.reduce(min);
                      if (mininumscore < 0) {
                        mininumscore -= 20;
                      }
                      List<BarValue<void>> minimumlist = [];
                      for (int i = 0; i < scores.length; i++) {
                        minimumlist.add(BarValue(mininumscore.toDouble()));
                      }
                      List<BarValue<void>> chartdatalist = [];
                      for (int i = 0; i < scores.length; i++) {
                        chartdatalist.add(BarValue(scores[i].toDouble()));
                      }
                      List<BarValue<void>> containerlist = [];
                      for (int i = 0; i < scores.length; i++) {
                        containerlist.add(BarValue(120.0));
                      }
                      return Chart<void>(
                        height: MediaQuery.of(context).size.height * 0.6,
                        state: ChartState(
                          ChartData(
                            [
                              minimumlist,
                              containerlist,
                              chartdatalist,
                            ],
                            axisMax: 120,
                          ),
                          itemOptions: BarItemOptions(
                            colorForKey: (item, key) {
                              return [
                                Theme.of(context).scaffoldBackgroundColor,
                                const Color.fromARGB(255, 149, 207, 140),
                                Colors.green,
                              ][key];
                            },
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            radius: const BorderRadius.vertical(
                                top: Radius.circular(42.0)),
                          ),
                          backgroundDecorations: [
                            GridDecoration(
                              textStyle: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              showHorizontalGrid: false,
                              showVerticalGrid: false,
                              verticalAxisStep: 1,
                              horizontalAxisStep: 10,
                              showVerticalValues: true,
                              verticalAxisValueFromIndex: _daynamefromindex,
                            )
                          ],
                          foregroundDecorations: [
                            ValueDecoration(
                                valueArrayIndex: 2,
                                alignment: Alignment.bottomCenter,
                                textStyle: const TextStyle(color: Colors.black),
                                valueGenerator: _valuegenerator),
                            TargetLineDecoration(
                                target: 220.0,
                                targetLineColor: Colors.black,
                                lineWidth: 1.0),
                          ],
                          behaviour: const ChartBehaviour(
                            isScrollable: true,
                          ),
                        ),
                      );
                    }
                }
              })
        ],
      ),
    );
  }
}
