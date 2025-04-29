import 'package:flutter/material.dart';
import '../models/product.dart';

class CustomProductForm extends StatelessWidget {
  final Product? product;
  final void Function(Product) onSubmit;

  const CustomProductForm({
    this.product,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: product?.title ?? '');
    final _priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final _descriptionController =
        TextEditingController(text: product?.description ?? '');
    final _imageController =
        TextEditingController(text: product?.image ?? '');

    return AlertDialog(
      backgroundColor: Colors.transparent, // Make background transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
      content: Container(
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product == null ? 'Add Product' : 'Edit Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800], // Neutral text color
                  fontFamily: 'Poppins', // Apply Poppins font
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[600]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[600]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[600]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[600]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.blueGrey[800]), // Neutral text color
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final newProduct = Product(
              id: product?.id ?? 0,
              title: _titleController.text,
              price: double.tryParse(_priceController.text) ?? 0.0,
              description: _descriptionController.text,
              image: _imageController.text,
            );
            onSubmit(newProduct);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[600], // Neutral button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            product == null ? 'Add' : 'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
