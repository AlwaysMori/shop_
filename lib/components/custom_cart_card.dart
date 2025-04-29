import 'package:flutter/material.dart';

class CustomCartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onRemove;

  const CustomCartCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0, // Remove default elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Square corners
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black, // Solid black shadow
              offset: Offset(4, 4), // Shadow on the right and bottom
              blurRadius: 0, // No blur for solid shadow
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(0), // Square corners
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.grey);
              },
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300, // Light weight
              color: Colors.blueGrey[800], // Slightly darker text color
              fontFamily: 'Poppins', // Apply Poppins font
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey[600], // Slightly lighter text color
              fontFamily: 'Poppins', // Apply Poppins font
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
          ),
        ),
      ),
    );
  }
}
