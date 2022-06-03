import 'package:flutter/material.dart';
import 'package:tracker/controller/form_controller.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FetchUserData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading....');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length, //length of players list
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
                                snapshot.data.keys.toList()[index].toString() +
                                " " +
                                snapshot.data.values
                                    .toList()[index]
                                    .toString() +
                                " pts",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                );
              }
          }
        });
  }
}

  /*Map _leaderboardvalues = {"couldn't load your friends' points": ""};
  Timer _every15secs = Timer.periodic(Duration(seconds: 15), (timer) {});

  void getleaderboard() async {
    FormController formController = FormController();
    Map leaderboardmap = await formController.GetUserData();
    setState(() {
      _leaderboardvalues = leaderboardmap;
    });
  }

  @override
  void initState() {
    super.initState();
    _every15secs = Timer.periodic(Duration(seconds: 15), (timer) {
      getleaderboard();
    });
  }*/
