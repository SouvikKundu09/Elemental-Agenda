import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:elemental_agenda_app/classes/db_helper.dart';
// import 'package:elemental_agenda_app/components/eventform.dart';
// import 'package:elemental_agenda_app/components/eventcard.dart';
import 'package:elemental_agenda_app/components/eventlist.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  void _setDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/form");
        },
      ),
      backgroundColor: const Color(0xFF1e1e2e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Text(
                  'Elemental Agenda',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              CalendarTimeline(
                showYears: true,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 1)),
                onDateSelected: (date) => _setDate(date),
                monthColor: Colors.white70,
                dayColor: const Color(0xff94e2d5),
                dayNameColor: const Color(0xFF333A47),
                activeDayColor: const Color(0xff11111b),
                activeBackgroundDayColor: const Color(0xfff2cdcd),
                dotsColor: const Color(0xFF333A47),
                locale: 'en',
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xff94e2d5),
                  ),
                ),
                child: const Text(
                  'Jump to today',
                  style: TextStyle(color: Color(0xFF333A47)),
                ),
                onPressed: () => setState(() => _resetSelectedDate()),
              ),
              const SizedBox(height: 20),

              FutureBuilder(
                future: DatabaseHelper().fetchData(_selectedDate),
                builder: (context, snapshot) {
                  var list = snapshot.data ?? [];

                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                        child: Text("Something wrong happened"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      // height: 300,
                      child: EventList(ev: list),
                    );
                  }
                },
              )

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              //   child: EventCard(name: "Test Event"),
              // ),
              // const SizedBox(height: 20),
              // Center(
              //   child: Text(
              //     'No event in $_selectedDate',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
