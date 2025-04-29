import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const CustomSearchBar({
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50], // Match theme background
          borderRadius: BorderRadius.circular(0), // Square corners
          boxShadow: [
            BoxShadow(
              color: Colors.black, // Solid black shadow
              offset: Offset(4, 4), // Shadow on the right and bottom
              blurRadius: 0, // No blur for solid shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(
              fontFamily: 'Poppins', // Apply Poppins font
              fontWeight: FontWeight.w300, // Light weight
              color: Colors.blueGrey, // Match theme color
            ),
            prefixIcon: Icon(Icons.search, color: Colors.blueGrey), // Match theme color
            filled: true,
            fillColor: Colors.transparent, // Transparent to match container color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0), // Square corners
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => onSearch(),
        ),
      ),
    );
  }
}
