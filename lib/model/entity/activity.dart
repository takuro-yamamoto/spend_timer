import 'dart:ui';

class Activity {
  int? id;
  String title;
  String description;
  int durationInSeconds;
  DateTime createdTime;
  Color? color;

  Activity(
      {this.id,
      required this.title,
      required this.description,
      required this.durationInSeconds,
      required this.createdTime,
      this.color});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration_in_seconds': durationInSeconds,
      'created_time': createdTime.toIso8601String(),
    };
  }

  static Activity fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      durationInSeconds: map['duration_in_seconds'],
      createdTime: DateTime.parse(map['created_time']),
    );
  }
}
