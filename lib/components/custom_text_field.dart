import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], 
        borderRadius: BorderRadius.circular(0), 
        boxShadow: [
          BoxShadow(
            color: Colors.black, 
            offset: Offset(4, 4), 
            blurRadius: 0, 
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300, 
            color: Colors.blueGrey,
          ),
          prefixIcon: Icon(icon, color: Colors.blueGrey), 
          filled: true,
          fillColor: Colors.transparent, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0), 
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
