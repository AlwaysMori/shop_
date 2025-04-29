import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/employee.dart';

class EmployeeService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<List<Employee>> getEmployees() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? employeesData = prefs.getString('employees');
    if (employeesData != null) {
      final List<dynamic> jsonList = jsonDecode(employeesData);
      return jsonList.map((json) => Employee.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveEmployee(Employee employee) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Employee> employees = await getEmployees();

    // Simpan password ke secure storage
    await _secureStorage.write(
      key: employee.username,
      value: employee.password,
    );

    // Simpan data lainnya ke SharedPreferences
    employees.add(Employee(
      username: employee.username,
      password: '', // Jangan simpan password di SharedPreferences
      name: employee.name,
      position: employee.position,
    ));
    final String jsonString =
        jsonEncode(employees.map((e) => e.toJson()).toList());
    await prefs.setString('employees', jsonString);
  }

  Future<bool> validateLogin(String username, String password) async {
    final String? storedPassword = await _secureStorage.read(key: username);
    return storedPassword == password;
  }

  Future<String?> getUserRole(String username, String password) async {
    final List<Employee> employees = await getEmployees();
    try {
      final employee = employees.firstWhere(
        (e) => e.username == username,
      );

      // Validasi password dari secure storage
      final String? storedPassword = await _secureStorage.read(key: username);
      if (storedPassword == password) {
        return employee.position;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
