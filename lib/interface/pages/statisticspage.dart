import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/controller/getlocaldata.dart';

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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
