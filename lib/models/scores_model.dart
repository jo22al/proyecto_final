class Score {
  final int id;
  final int time;
  final String level;
  final String currentDate;
  final String currentTime;
  final int studentId;

  Score({
    required this.id,
    required this.time,
    required this.level,
    required this.currentDate,
    required this.currentTime,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'level': level,
      'currentDate': currentDate,
      'currentTime': currentTime,
      'student_id': studentId,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'],
      time: map['time'],
      level: map['level'],
      currentDate: map['currentDate'],
      currentTime: map['currentTime'],
      studentId: map['student_id'],
    );
  }
}
