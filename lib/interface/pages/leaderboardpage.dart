import 'package:flutter/material.dart';
import 'leaderboardwidget.dart';
import 'dart:async';

class LeaderboardPage extends StatelessWidget {
  LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Leaderboard',
              style: TextStyle(
                color: Color.fromARGB(255, 39, 19, 49),
                fontSize: 26,
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
              ),
              textScaleFactor: 1.3),
        ),
        body: Center(
          child: Container(
              color: Colors.white10,
              alignment: Alignment.center,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: LeaderBoard(),
                  ),
                ],
              )),
        ));
  }
}
