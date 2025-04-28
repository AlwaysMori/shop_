import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/employee.dart';

class EmployeeService {
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
    employees.add(employee);
    final String jsonString =
        jsonEncode(employees.map((e) => e.toJson()).toList());
    await prefs.setString('employees', jsonString);
  }

  Future<bool> validateLogin(String username, String password) async {
    final List<Employee> employees = await getEmployees();
    return employees.any(
        (employee) => employee.username == username && employee.password == password);
  }

  Future<String?> getUserRole(String username, String password) async {
    final List<Employee> employees = await getEmployees();
    try {
      final employee = employees.firstWhere(
        (e) => e.username == username && e.password == password,
      );
      return employee.position; 
    } catch (e) {
      return null; 
    }
  }
}
