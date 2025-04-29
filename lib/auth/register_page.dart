import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'login_page.dart';
import '../components/custom_text_field.dart';
import '../components/custom_button.dart';
import '../components/page_title.dart';
import '../components/responsive_padding.dart';
import '../components/custom_dropdown.dart';
import '../components/notification_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _position = 'Manager';
  final EmployeeService _employeeService = EmployeeService();

  Future<bool> _isUsernameDuplicate(String username) async {
    final List<Employee> employees = await _employeeService.getEmployees();
    return employees.any((employee) => employee.username == username);
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text.trim();

      // Periksa apakah username sudah ada
      if (await _isUsernameDuplicate(username)) {
        NotificationHelper.showNotification(
          context,
          'Username already exists. Please choose another one.',
          isError: true,
        );
        return;
      }

      final Employee newEmployee = Employee(
        username: username,
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        position: _position,
      );

      try {
        await _employeeService.saveEmployee(newEmployee);

        NotificationHelper.showNotification(
          context,
          'Employee registered successfully!',
        );

        _usernameController.clear();
        _passwordController.clear();
        _nameController.clear();
        setState(() {
          _position = 'Manager';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        NotificationHelper.showNotification(
          context,
          'Failed to register employee: $e',
          isError: true,
        );
      }
    } else {
      NotificationHelper.showNotification(
        context,
        'Please fill out all fields correctly.',
        isError: true,
      );
    }
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ResponsivePadding(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  PageTitle(title: 'Register'),
                  SizedBox(height: 40),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextField(
                      controller: _nameController,
                      hintText: 'Employee Name',
                      icon: Icons.badge,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the employee name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Row(
                      children: [
                        Text(
                          'Jabatan:',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CustomDropdown<String>(
                            value: _position,
                            items: ['Manager', 'Cashier'],
                            hintText: 'Select Position',
                            onChanged: (value) {
                              setState(() {
                                _position = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Register',
                    onPressed: _saveEmployee,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _navigateToLoginPage(context),
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}
