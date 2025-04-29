import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Text(
      title,
      style: TextStyle(
        fontSize: isDesktop ? 40 : 32, // Larger font for desktop
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
