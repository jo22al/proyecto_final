class User {
  final int id;
  final String email;
  final String password;
  // final String role;

  User({
    required this.id,
    required this.email,
    required this.password,
    // required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      // role: map['role'],
    );
  }
}
