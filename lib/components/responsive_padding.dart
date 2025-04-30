import 'package:flutter/material.dart';

class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 200.0 : 24.0, 
      ),
      child: child,
    );
  }
}
