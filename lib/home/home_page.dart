import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../components/custom_card.dart';
import '../components/custom_product_form.dart';
import '../home/detail/detail_product.dart';

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
        backgroundColor: Colors.blue, // Warna biru untuk AppBar
      ),
      body: Container(
        color: Colors.blue[50], // Latar belakang putih kebiruan
        child: productProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : productProvider.products.isEmpty
                ? Center(child: Text('No products available.'))
                : ListView.builder(
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProductPage(product: product),
                          ),
                        ),
                        child: CustomCard(
                          title: product.title,
                          subtitle: '\$${product.price.toStringAsFixed(2)}',
                          imageUrl: product.image,
                          onEdit: () => _showProductForm(context, product: product),
                          onDelete: () =>
                              productProvider.deleteProduct(product.id),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showProductForm(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomProductForm(
          product: product,
          onSubmit: (newProduct) {
            if (product == null) {
              Provider.of<ProductProvider>(context, listen: false)
                  .addProduct(newProduct);
            } else {
              Provider.of<ProductProvider>(context, listen: false)
                  .updateProduct(newProduct);
            }
          },
        );
      },
    );
  }
}
