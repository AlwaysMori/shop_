import 'package:flutter/material.dart';

class CustomTotalPaymentCard extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final VoidCallback onComplete;

  const CustomTotalPaymentCard({
    required this.totalItems,
    required this.totalPrice,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500, // Medium weight
                color: Colors.blueGrey[800], // Slightly darker text color
                fontFamily: 'Poppins', // Apply Poppins font
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Apply Poppins font
                    color: Colors.blueGrey[700], // Slightly lighter text color
                  ),
                ),
                Text(
                  '$totalItems',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium weight
                    color: Colors.blueGrey[800], // Slightly darker text color
                    fontFamily: 'Poppins', // Apply Poppins font
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Apply Poppins font
                    color: Colors.blueGrey[700], // Slightly lighter text color
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium weight
                    color: Colors.blueGrey[800], // Slightly darker text color
                    fontFamily: 'Poppins', // Apply Poppins font
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey, // Match theme color
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Apply Poppins font
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onComplete();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Match theme color
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Square corners
                    ),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins', // Apply Poppins font
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
