import 'package:flutter/material.dart';
import 'package:validators/validators.dart'; // Import for URL validation
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/local_storage_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  final LocalStorageService _localStorageService = LocalStorageService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  bool isValidUrl(String url) {
    return isURL(url); // Validate only if it's a valid URL
  }

//1. (Memanggil fetchProducts() dan memasukkan ke list)
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Load products from local storage first
      final localProducts = await _localStorageService.getProducts();
      if (localProducts.isNotEmpty) {
        setState(() {
          _products = localProducts;
        });
      } else {
        // If no local data, fetch from server
        final fetchedProducts = await _productService.fetchProducts();
        setState(() {
          _products = fetchedProducts;
        });
        // Save fetched data to local storage
        await _localStorageService.saveProducts(_products);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProductsLocally() async {
    await _localStorageService.saveProducts(_products);
  }
  
//2.(Formulir untuk tambah produk)
  void _showProductForm({Product? product}) {
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
              onPressed: () async {
                final imageUrl = _imageController.text;
                if (!isValidUrl(imageUrl)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid image URL')),
                  );
                  return;
                }

                final newProduct = Product(
                  id: product?.id ?? (_products.isNotEmpty
                      ? _products.last.id + 1
                      : 1), // Generate a unique ID
                  title: _titleController.text,
                  price: double.parse(_priceController.text),
                  description: _descriptionController.text,
                  image: imageUrl,
                );

                try {//3.(Formulir untuk tambah dan edit produk)
                  if (product == null) {
                    final addedProduct = await _productService.addProduct(newProduct);
                    setState(() {
                      _products.add(addedProduct);
                    }); 
                  } else {
                    await _productService.updateProduct(product.id, newProduct);
                    setState(() {
                      final index = _products.indexWhere((p) => p.id == product.id);
                      if (index != -1) {
                        _products[index] = newProduct;
                      }
                    });
                  }
                  await _saveProductsLocally(); // Save updated products locally
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save product: $e')),
                  );
                }
              },
              child: Text(product == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _productService.deleteProduct(id);
        setState(() {
          _products.removeWhere((product) => product.id == id);
        });
        await _saveProductsLocally(); // Save updated products locally
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadProducts,
          ), //2.(Untuk membuka form tambah produk)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showProductForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Center(child: Text('No products available.'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 50);
                        },
                      ), // Show broken image icon
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showProductForm(product: product),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteProduct(product.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
