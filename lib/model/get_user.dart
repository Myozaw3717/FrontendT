class User {
  final int user_id;
  final String name;
  final String email;
  final String role;
  final String password;

  const User({
    required this.user_id,
    required this.name,
    required this.email,
    required this.role,
    required this.password
  });
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      user_id:  int.parse(json['user_id'].toString()),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString()?? '',
      password: json['password']?.toString()?? '',
      role: json['role']?.toString()?? '',

    );
}
}