import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String hintText;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Colors.blueGrey, 
              fontFamily: 'Poppins', 
              fontWeight: FontWeight.w300, 
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: 'Poppins', 
                        fontWeight: FontWeight.w300, 
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey), 
        ),
      ),
    );
  }
}
