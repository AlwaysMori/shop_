import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.blueGrey, // Warna lebih lembut
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.5), // Warna lebih lembut
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.2), // Warna lebih lembut
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'Poppins', // Apply Poppins font
            ),
          ),
        ),
      ),
    );
  }
}
