import 'package:flutter/material.dart';
import 'package:tracker/controller/form_controller.dart';
import 'package:platform_device_id/platform_device_id.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  Future<String> getDeviceId() async {
    String deviceid =
        await PlatformDeviceId.getDeviceId ?? "Failed to retrieve deviceid";
    print(deviceid);
    return deviceid;
  }

  String createemojiindex(int index) {
    String emoji = '';
    switch (index) {
      case 0:
        emoji = '🥇 ';
        break;
      case 1:
        emoji = '🥈 ';
        break;
      case 2:
        emoji = '🥉 ';
        break;
      default:
        emoji = (index + 1).toString() + ". ";
        break;
    }
    return emoji;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([FetchUserData(), getDeviceId()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading....');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data[0].length, //length of players list
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  itemBuilder: (context, index) {
                    String homedeviceid = snapshot.data[1];
                    String currentdeviceid =
                        snapshot.data[0].keys.toList()[index].toString();
                    bool ishomedevice = homedeviceid == currentdeviceid;
                    String cardtitle = (createemojiindex(index) +
                        currentdeviceid +
                        " " +
                        snapshot.data[0].values.toList()[index].toString() +
                        " pts");
                    TextStyle cardtitlestyle = const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold);
                    return Card(
                      color: ishomedevice ? Colors.green : Colors.white,
                      child: ListTile(
                        onTap: () {},
                        title: ishomedevice
                            ? Text(
                                cardtitle + " (You)",
                                style: cardtitlestyle,
                              )
                            : Text(
                                cardtitle,
                                style: cardtitlestyle,
                              ),
                      ),
                    );
                  },
                );
              }
          }
        });
  }
}
