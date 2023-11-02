class Student {
  final int id;
  final String codigo;
  final String name;
  final String lastname;
  final String dateOfBirth;
  final int bestEasyLevel;
  final int bestMediumLevel;
  final int bestHardLevel;
  final int teacherId;
  final String? teacherName;
  final String? teacherLastname;

  Student({
    required this.id,
    required this.codigo,
    required this.name,
    required this.lastname,
    required this.dateOfBirth,
    required this.bestEasyLevel,
    required this.bestMediumLevel,
    required this.bestHardLevel,
    required this.teacherId,
    this.teacherName,
    this.teacherLastname,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      codigo: map['codigo'],
      name: map['name'],
      lastname: map['lastname'],
      dateOfBirth: map['dateOfBirth'],
      bestEasyLevel: map['bestEasyLevel'],
      bestMediumLevel: map['bestMediumLevel'],
      bestHardLevel: map['bestHardLevel'],
      teacherId: map['teacher_id'],
      teacherName: map['teacher_name'],
      teacherLastname: map['teacher_lastname'],
    );
  }
}
