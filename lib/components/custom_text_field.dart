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
        color: Colors.blueGrey[50], // Warna lebih lembut
        borderRadius: BorderRadius.circular(0), // No corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.black, // Solid black shadow
            offset: Offset(4, 4), // Shadow on the right and bottom
            blurRadius: 0, // No blur for solid shadow
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
            fontWeight: FontWeight.w300, // Apply Poppins font
            color: Colors.blueGrey, // Match the icon color
          ),
          prefixIcon: Icon(icon, color: Colors.blueGrey), // Warna lebih lembut
          filled: true,
          fillColor: Colors.transparent, // Transparent to match container color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0), // No corner radius
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
