class UpdateUser{
  final String name;
  final String email;
  final String role;
  final String? password;

  const UpdateUser({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });
  Map<String,dynamic> toJson() {
    final Map<String,dynamic> data = {
      'name':name,
      'email':email,
      'role':role,
    };
    if (password != null && password!.isNotEmpty) {
      data['password']= password ;
    }
    return data;
  }
}