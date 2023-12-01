import 'package:elemental_agenda_app/components/eventcard.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';

class EventList extends StatelessWidget {
  // final List<String> events = ["Event A", "Event B"];

  final List<dynamic> ev;

  const EventList({super.key, required this.ev});

  @override
  Widget build(BuildContext context) {
    if (ev.isEmpty) {
      return Center(
        child: Text(
          'No event in this day',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, idx) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: EventCard(event: Event.fromMap(ev[idx])),
      ),
      itemCount: ev.length,
    );
  }
}
