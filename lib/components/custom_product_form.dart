import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan ini untuk Clipboard
import '../models/product.dart';

class CustomProductForm extends StatefulWidget {
  final Product? product;
  final void Function(Product) onSubmit;

  const CustomProductForm({
    this.product,
    required this.onSubmit,
  });

  @override
  _CustomProductFormState createState() => _CustomProductFormState();
}

class _CustomProductFormState extends State<CustomProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
        text: widget.product?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _imageController =
        TextEditingController(text: widget.product?.image ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 600;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: isDesktop ? 500 : double.infinity, // Adjust width for desktop
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.product == null ? 'Add Product' : 'Edit Product',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _titleController,
                      label: 'Title',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _priceController,
                      label: 'Price',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price is required';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _imageController,
                      label: 'Image URL',
                      icon: Icons.image,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Image URL is required';
                        }
                        final urlPattern = r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w\.-]*)*\/?$';
                        final isValidUrl = RegExp(urlPattern).hasMatch(value);
                        if (!isValidUrl) {
                          return 'Enter a valid URL';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey[100], // Tambahkan background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newProduct = Product(
                    id: widget.product?.id ?? 0,
                    title: _titleController.text,
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    description: _descriptionController.text,
                    image: _imageController.text,
                  );
                  widget.onSubmit(newProduct);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: Colors.white, // Pastikan teks tetap putih
              ),
              child: Text(
                widget.product == null ? 'Add' : 'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    // Tambahkan logika khusus untuk Image URL
    final isImageField = label == 'Image URL';
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blueGrey[600],
          selectionHandleColor: Colors.blueGrey[600],
        ),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.blueGrey[600],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey[600]),
          labelStyle: TextStyle(color: Colors.blueGrey[800]),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[600]!),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          // Tambahkan icon paste jika field Image URL
          suffixIcon: isImageField
              ? IconButton(
                  icon: Icon(Icons.paste, color: Colors.blueGrey[600]),
                  tooltip: 'Paste from clipboard',
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data != null && data.text != null) {
                      controller.text = data.text!;
                    }
                  },
                )
              : null,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
