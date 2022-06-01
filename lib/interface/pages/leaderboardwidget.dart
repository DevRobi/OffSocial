import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Map leaderboardvalues = {"couldn't load your friends' points": ""};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: leaderboardvalues.length, //length of players list
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(
                  (index + 1).toString() +
                      ". " +
                      leaderboardvalues.keys.toList()[index].toString() +
                      " " +
                      leaderboardvalues.values.toList()[index].toString() +
                      " pts",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          );
        });
  }
}
