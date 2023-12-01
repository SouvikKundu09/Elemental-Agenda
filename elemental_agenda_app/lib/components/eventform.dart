import 'package:elemental_agenda_app/classes/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../classes/event.dart';

class Eventform extends StatefulWidget {
  const Eventform({super.key});

  @override
  State<Eventform> createState() => _EventformState();
}

class _EventformState extends State<Eventform> {
  final _key = GlobalKey<FormState>();

  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventLocationController =
      TextEditingController(text: 'Select a Location');

  DateTime startDate = DateTime.now().add(const Duration(hours: 1));
  final startDateController = TextEditingController(
      text: DateFormat("dd/MM/yyyy KK:mm a")
          .format(DateTime.now().add(const Duration(hours: 1))));
  DateTime endDate = DateTime.now().add(const Duration(hours: 2));
  final endDateController = TextEditingController(
      text: DateFormat("dd/MM/yyyy KK:mm a")
          .format(DateTime.now().add(const Duration(hours: 2))));

  String city = "Tempe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11111b),
      appBar: AppBar(
        title: const Text("Add new event"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: eventNameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Event Name",
                        labelStyle: TextStyle(
                          color: Color(0xff74c7ec),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xffffffff)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Pick Date Range",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xff74c7ec),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(children: [
                      const Text("Start date:"),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: startDateController,
                          style: const TextStyle(
                            color: Color(0xffaaaaaa),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const Text("End date:"),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: endDateController,
                          style: const TextStyle(
                            color: Color(0xffaaaaaa),
                          ),
                        ),
                      ),
                    ]),
                    IconButton(
                      onPressed: () async {
                        List<DateTime>? dateTimeList =
                            await showOmniDateTimeRangePicker(
                          context: context,
                          startInitialDate: startDate,
                          startFirstDate: DateTime.now(),
                          startLastDate: DateTime.now().add(
                            const Duration(days: 1460),
                          ),
                          endInitialDate: endDate,
                          endFirstDate: DateTime.now(),
                          endLastDate: DateTime.now().add(
                            const Duration(days: 1460),
                          ),
                          is24HourMode: false,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          isForce2Digits: true,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          constraints: const BoxConstraints(
                            maxWidth: 350,
                            maxHeight: 650,
                          ),
                          transitionBuilder: (context, anim1, anim2, child) {
                            return FadeTransition(
                              opacity: anim1.drive(
                                Tween(
                                  begin: 0,
                                  end: 1,
                                ),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 200),
                          barrierDismissible: true,
                          selectableDayPredicate: (dateTime) {
                            // Disable Creating Past Dates
                            if (dateTime.millisecondsSinceEpoch <
                                DateTime.now().millisecondsSinceEpoch) {
                              return false;
                            } else {
                              return true;
                            }
                          },
                        );
                        setState(() {
                          startDate = dateTimeList != null
                              ? dateTimeList[0]
                              : DateTime.now().add(const Duration(hours: 1));
                          startDateController.text =
                              DateFormat("dd/MM/yyyy KK:mm a")
                                  .format(startDate);
                          endDate = dateTimeList != null
                              ? dateTimeList[1]
                              : DateTime.now().add(const Duration(hours: 2));
                          endDateController.text =
                              DateFormat("dd/MM/yyyy KK:mm a").format(endDate);
                        });
                      },
                      icon: const Icon(
                        Icons.date_range_rounded,
                        color: Color(0xff11111b),
                      ),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xff94e2d5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: eventDescriptionController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Event Description",
                        labelStyle: TextStyle(
                          color: Color(0xff74c7ec),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xffffffff)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: eventLocationController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Event Location",
                        labelStyle: TextStyle(
                          color: Color(0xff74c7ec),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Color(0xffcccccc),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xffffffff)),
                      onTap: () async {
                        LocationData? locationData = await LocationSearch.show(
                            context: context,
                            lightAdress: true,
                            mode: Mode.overlay);
                        setState(() {
                          eventLocationController.text = locationData!.address;
                          city = locationData.addressData["city"];
                          print("Form city $city");
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xfff38ba8),
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                          Color(0xff11111b),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xffa6e3a1),
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                          Color(0xff11111b),
                        ),
                      ),
                      onPressed: () async {
                        Event e = Event(
                            name: eventNameController.text,
                            location: eventLocationController.text,
                            description: eventDescriptionController.text,
                            start: startDate,
                            end: endDate,
                            city: city);
                        await DatabaseHelper().insertData(e.toMap());
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/", (route) => false);
                      },
                      child: const Text("Create Event"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
