import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  Future<List> getJobsData() async {
    String url =
        'https://firebasestorage.googleapis.com/v0/b/ecosolutions-73ab2.appspot.com/o/sensores.json?alt=media&token=09ac9e63-744d-4286-aae1-c4eadd81c026';

    var response = await http.get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });
    print(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder<List>(
                future: getJobsData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          var title = snapshot.data![index]['nombre'];
                          var company =
                              snapshot.data![index]['description_tiempo'];
                          var skills = snapshot.data![index]['numero_sensor'];
                          var description = snapshot.data![index]['presion'];
                          var positions =
                              snapshot.data![index]['direccin_viento'];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.green.shade300),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Text(skills.toString()),
                                  title: Text(title),
                                  subtitle: Text(
                                    company + '\n' + description.toString(),
                                  ),
                                  trailing: Text(positions.toString()),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
