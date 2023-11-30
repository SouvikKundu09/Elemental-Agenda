class Event {
  String name;
  DateTime start;
  DateTime end;
  String description;
  String location;

  Event(
      {required this.name,
      required this.start,
      required this.end,
      required this.description,
      required this.location});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapping = {};

    // for (var entry in entries) {
    //   mapping[entry.symptomName] = entry.rating;
    // }

    mapping['name'] = name;
    mapping['start'] = start.millisecondsSinceEpoch;
    mapping['end'] = end.millisecondsSinceEpoch;
    mapping['description'] = description;
    mapping['location'] = location;

    return mapping;
  }

  static Event fromMap(Map<String, dynamic> m) {
    Event e = Event(
      name: m['name'],
      start: DateTime.fromMillisecondsSinceEpoch(m['start']),
      end: DateTime.fromMillisecondsSinceEpoch(m['end']),
      description: m['description'],
      location: m['location'],
    );

    return e;
  }
}