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
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.blueGrey,
              selectionHandleColor: Colors.blueGrey,
            ),
          ),
          child: TextField(
            controller: controller,
            cursorColor: Colors.blueGrey, 
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                fontFamily: 'Poppins', 
                fontWeight: FontWeight.w300, 
                color: Colors.blueGrey, 
              ),
              prefixIcon: Icon(Icons.search, color: Colors.blueGrey), 
              filled: true,
              fillColor: Colors.transparent, 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
      ),
    );
  }
}
