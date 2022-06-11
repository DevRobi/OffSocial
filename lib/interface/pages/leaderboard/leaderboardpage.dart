// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'leaderboardwidget.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderboardPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {});
          },
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: const Text('Leaderboard',
              style: TextStyle(
                color: Colors.white,
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

  @override
  bool get wantKeepAlive => true;
}
