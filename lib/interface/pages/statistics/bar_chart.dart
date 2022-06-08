import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/getlocaldata.dart';
import "statisticspage.dart";

class BarChart extends StatefulWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
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
                        return Chart<void>(
                          height: 600.0,
                          state: ChartState(
                            ChartData.fromList(
                              scores!
                                  .map((e) => BarValue<void>(e.toDouble()))
                                  .toList(),
                              axisMax: 8.0,
                            ),
                            itemOptions: const BarItemOptions(
                              color: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              radius: BorderRadius.vertical(
                                  top: Radius.circular(42.0)),
                            ),
                            backgroundDecorations: [
                              GridDecoration(
                                verticalAxisStep: 1,
                                horizontalAxisStep: 1,
                              ),
                            ],
                            foregroundDecorations: [
                              BorderDecoration(
                                borderWidth: 5.0,
                              ),
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
