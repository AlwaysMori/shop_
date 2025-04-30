import 'package:flutter/material.dart';
import '../../models/product.dart';

class DetailProductPage extends StatelessWidget {
  final Product product;

  const DetailProductPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            fontFamily: 'Poppins', // Apply Poppins font
            fontWeight: FontWeight.w300, // Light weight
          ),
        ),
        backgroundColor: Colors.blueGrey, // Match home page theme
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 600;
          return Container(
            color: const Color(0xFFB9C5C5), // Match home page background color
            padding: EdgeInsets.all(16.0),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0), // Square corners
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildProductDetails(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0), // Square corners
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildProductDetails(),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300, // Light weight
                color: Colors.blueGrey, // Match theme color
                fontFamily: 'Poppins', // Apply Poppins font
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.blueGrey, thickness: 1), // Match theme color
            SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300, // Light weight
                color: Colors.green, // Keep green for price
                fontFamily: 'Poppins', // Apply Poppins font
              ),
            ),
            Divider(color: Colors.blueGrey, thickness: 1), // Match theme color
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300, // Light weight
                color: Colors.blueGrey, // Match theme color
                fontFamily: 'Poppins', // Apply Poppins font
              ),
            ),
            SizedBox(height: 10),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[700], // Slightly darker blue-grey
                fontFamily: 'Poppins', // Apply Poppins font
              ),
            ),
          ],
        ),
      ),
    );
  }
}
