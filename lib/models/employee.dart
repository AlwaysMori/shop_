class Employee {
  final String username;
  final String password;
  final String name;
  final String position;

  Employee({
    required this.username,
    required this.password,
    required this.name,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      position: json['position'],
    );
  }

  Map<String, String> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'position': position,
    };
  }
}
