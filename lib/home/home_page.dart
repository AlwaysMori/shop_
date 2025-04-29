import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../components/custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load products when the page is first opened
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: productProvider.loadProducts,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showProductForm(context),
          ),
        ],
      ),
      body: productProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : productProvider.products.isEmpty
              ? Center(child: Text('No products available.'))
              : ListView.builder(
                  itemCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return CustomCard(
                      title: product.title,
                      subtitle: '\$${product.price.toStringAsFixed(2)}',
                      imageUrl: product.image,
                      onEdit: () => _showProductForm(context, product: product),
                      onDelete: () =>
                          productProvider.deleteProduct(product.id),
                    );
                  },
                ),
    );
  }

  void _showProductForm(BuildContext context, {Product? product}) {
    final _titleController = TextEditingController(text: product?.title ?? '');
    final _priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final _descriptionController =
        TextEditingController(text: product?.description ?? '');
    final _imageController =
        TextEditingController(text: product?.image ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProduct = Product(
                  id: product?.id ?? 0,
                  title: _titleController.text,
                  price: double.parse(_priceController.text),
                  description: _descriptionController.text,
                  image: _imageController.text,
                );

                if (product == null) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .addProduct(newProduct);
                } else {
                  Provider.of<ProductProvider>(context, listen: false)
                      .updateProduct(newProduct);
                }

                Navigator.pop(context);
              },
              child: Text(product == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}
