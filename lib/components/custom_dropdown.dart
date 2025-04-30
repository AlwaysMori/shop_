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
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.blueGrey,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
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
      ),
    );
  }
}
