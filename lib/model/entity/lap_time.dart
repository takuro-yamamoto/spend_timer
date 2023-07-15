class LapTime {
  final int? id;
  final int activityId;
  final int lapTime;
  final DateTime createdTime;

  LapTime({
    this.id,
    required this.activityId,
    required this.lapTime,
    required this.createdTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'activity_id': activityId,
      'lap_time': lapTime,
      'created_time': createdTime.toIso8601String(),
    };
  }

  static LapTime fromMap(Map<String, dynamic> map) {
    return LapTime(
      id: map['id'],
      activityId: map['activity_id'],
      lapTime: map['lap_time'],
      createdTime: DateTime.parse(map['created_time']),
    );
  }
}
