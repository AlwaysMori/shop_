import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'login_page.dart';

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

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final Employee newEmployee = Employee(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        position: _position,
      );

      try {
        await _employeeService.saveEmployee(newEmployee);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee registered successfully!')),
        );

        _usernameController.clear();
        _passwordController.clear();
        _nameController.clear();
        setState(() {
          _position = 'Manager';
        });

        // Navigate to login page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register employee: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Pegawai'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the employee name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _position,
                items: ['Manager', 'Cashier']
                    .map((position) => DropdownMenuItem(
                          value: position,
                          child: Text(position),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _position = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Position'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Punya akun? Login'),
              ),
            ],
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
