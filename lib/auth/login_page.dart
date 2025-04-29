import 'package:flutter/material.dart';
import '../services/employee_service.dart';
import '../home/home_page.dart';
import '../home/cashier_page.dart';
import 'register_page.dart';
import '../components/custom_text_field.dart';
import '../components/custom_button.dart';
import '../components/notification_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EmployeeService _employeeService = EmployeeService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final bool isValid = await _employeeService.validateLogin(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (isValid) {
          final String? role = await _employeeService.getUserRole(
            _usernameController.text.trim(),
            _passwordController.text.trim(),
          );

          if (role != null) {
            NotificationHelper.showNotification(
              context,
              'Login successful!',
            );

            if (role == 'Manager') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (role == 'Cashier') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CashierPage()),
              );
            }
          }
        } else {
          NotificationHelper.showNotification(
            context,
            'Invalid username or password',
            isError: true,
          );
        }
      } catch (e) {
        NotificationHelper.showNotification(
          context,
          'Failed to login: $e',
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

  void _navigateToRegisterPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
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
      backgroundColor: const Color(0xFFB9C5C5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 200.0 : 24.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Text(
                    'LOGIN PAGE',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300, 
                      color: Colors.blueGrey, 
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Image.asset(
                    'assets/images/login.png',
                    height: 250, 
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
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
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                      text: 'Login',
                      onPressed: _login,
                    ),
                  
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _navigateToRegisterPage(context),
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: Colors.blueGrey, 
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins', 
                    ),
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
