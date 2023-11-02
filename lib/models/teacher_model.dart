class Teacher {
  final int id;
  final String email;
  final String password;
  final String name;
  final String lastname;
  final String dateOfBirth;

  Teacher({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastname,
    required this.dateOfBirth,
  });

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      lastname: map['lastname'],
      dateOfBirth: map['dateOfBirth'],
    );
  }
}
