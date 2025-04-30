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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Payment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500, 
                color: Colors.blueGrey[800], 
                fontFamily: 'Poppins', 
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
                    fontFamily: 'Poppins',
                    color: Colors.blueGrey[700], 
                  ),
                ),
                Text(
                  '$totalItems',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[800], 
                    fontFamily: 'Poppins', 
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
                    fontFamily: 'Poppins', 
                    color: Colors.blueGrey[700], 
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, 
                    color: Colors.blueGrey[800], 
                    fontFamily: 'Poppins', 
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
                    foregroundColor: Colors.blueGrey,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Poppins', 
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onComplete();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, 
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), 
                    ),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins', 
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
