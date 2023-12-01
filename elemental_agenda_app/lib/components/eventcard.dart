import 'dart:convert';

import 'package:elemental_agenda_app/classes/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/event.dart';
import 'package:http/http.dart' as http;

class EventCard extends StatelessWidget {
  final Event event;
  final List<String> suggestions = [
    "a good suggestion",
    "another good suggestion"
  ];

  EventCard({super.key, required this.event});

  String returnDateString(DateTime d) {
    return DateFormat("KK:mm a").format(d);

    // int hour = d.hour > 12 ? d.hour % 12 : d.hour;
    // String ap = "am";
    // if (d.hour > 12 || (d.hour == 12 && d.minute > 0)) {
    //   ap = "pm";
    // } else if (d.hour == 12 && d.minute == 0) {
    //   ap = "noon";
    // }
    // return '$hour:${d.minute} $ap';
  }

  Color determineBackgroundcolor() {
    int currentTS = DateTime.now().millisecondsSinceEpoch;
    int startTS = event.start.millisecondsSinceEpoch;
    int endTS = event.end.millisecondsSinceEpoch;
    if (endTS < currentTS) {
      return const Color.fromARGB(255, 245, 189, 199);
    } else if (startTS < currentTS && currentTS < endTS) {
      return const Color.fromARGB(255, 252, 236, 202);
    } else {
      return const Color.fromARGB(255, 183, 235, 180);
    }
  }

  Future<String> getPrediction() async {
    try {
      print("Request City ${event.city}");
      http.Response res = await http.post(
          Uri.parse(
              "https://weather-prediction-flask.glitch.me/get_prediction"),
          headers: Map.from(
            <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          ),
          body: jsonEncode(<String, String>{
            "date": DateFormat('y-M-d').format(event.start),
            "location": event.city
          }));
      // print("This line!");
      Map<String, dynamic> resDecode = jsonDecode(res.body);
      // print(resDecode);
      return resDecode["prediction"] ?? "API Fail";
    } catch (e) {
      // print(e);
      return "Server AFK :/";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: determineBackgroundcolor(),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x23f1f1f1),
              offset: Offset(0, 3),
              blurRadius: 10,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff11111b),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${returnDateString(event.start)} to ${returnDateString(event.end)}",
                      style: const TextStyle(
                        color: Color(0xff11111b),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    event.location,
                    softWrap: true,
                    style: const TextStyle(color: Color(0xff333333)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(color: Color(0xff333333)),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xff000000),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Weather Prediction",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            FutureBuilder(
                future: getPrediction(),
                builder: (ctx, snapshot) {
                  var dt = snapshot.data ?? "No data obtained";
                  return Text(
                    dt,
                    style: const TextStyle(
                      color: Color(0xff11111b),
                    ),
                  );
                }),

            // Expanded(
            //   child: ListView.builder(
            //     itemBuilder: (ctx, i) => Text(
            //       "👉 ${suggestions[i]}",
            //       style: const TextStyle(
            //         color: Color(0xff000000),
            //         fontSize: 15,
            //       ),
            //     ),
            //     itemCount: suggestions.length,
            //   ),
            // ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            'Are you sure you want to delete this event?',
                            style: TextStyle(
                              color: Color(0xff777777),
                            ),
                          ),
                          Text(
                            'This actioin is not reversible!',
                            style: TextStyle(
                              color: Color(0xff777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancel',
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Delete',
                        ),
                        onPressed: () {
                          if (event.id != -1) {
                            DatabaseHelper().deleteEntry(event.id);
                          }
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil("/", (route) => false);
                        },
                      ),
                    ],
                  ),
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xfff38ba8)),
                textStyle: MaterialStatePropertyAll(
                  TextStyle(color: Color(0xff000000)),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Color(0xff000000),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Delete Event",
                    style: TextStyle(
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
