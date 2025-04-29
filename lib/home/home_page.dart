import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../components/custom_card.dart';
import '../components/custom_product_form.dart';
import '../components/custom_search_bar.dart';
import '../home/detail/detail_product.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProducts().then((_) {
        setState(() {
          _filteredProducts = productProvider.products;
        });
      });
    });
  }

  void _searchProducts() {
    final query = _searchController.text.toLowerCase();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      _filteredProducts = productProvider.products
          .where((product) => product.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(
            fontFamily: 'Poppins', // Apply Poppins font
            fontWeight: FontWeight.w300, // Light weight
          ),
        ),
        backgroundColor: Colors.blueGrey, // Match login page theme
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFB9C5C5), // Match login page background color
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onSearch: _searchProducts,
            ),
            Expanded(
              child: productProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products found.',
                            style: TextStyle(
                              fontFamily: 'Poppins', // Apply Poppins font
                              fontWeight: FontWeight.w300, // Light weight
                              color: Colors.blueGrey, // Match theme color
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductPage(product: product),
                                ),
                              ),
                              child: CustomCard(
                                title: product.title,
                                subtitle: '\$${product.price.toStringAsFixed(2)}',
                                imageUrl: product.image,
                                onEdit: () =>
                                    _showProductForm(context, product: product),
                                onDelete: () =>
                                    productProvider.deleteProduct(product.id),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: Colors.blueGrey, // Match login page theme
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

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
