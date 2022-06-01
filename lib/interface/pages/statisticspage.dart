import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  String? get deviceId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Your Stats. Now.',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
                decorationColor: Colors.black54,
                decorationStyle: TextDecorationStyle.solid,
                fontFamily: "alex"),
          )),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Text(
              "Your current score: " + "Loading...",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  decorationColor: Colors.black54,
                  decorationStyle: TextDecorationStyle.solid,
                  fontFamily: "alex"),
            ),
            const Text(
              "This weeks' best score: " + "Loading...",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  decorationColor: Colors.black54,
                  decorationStyle: TextDecorationStyle.solid,
                  fontFamily: "alex"),
            ),
            Chart<void>(
              height: 600.0,
              state: ChartState(
                ChartData.fromList(
                  [1, 3, 23, 2, 7, 6, 2, 5, 4]
                      .map((e) => BarValue<void>(e.toDouble()))
                      .toList(),
                  axisMax: 8.0,
                ),
                itemOptions: const BarItemOptions(
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  radius: BorderRadius.vertical(top: Radius.circular(42.0)),
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
            ),
          ],
        ),
      ),
    );
  }
}
