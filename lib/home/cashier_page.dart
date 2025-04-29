import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/local_storage_service.dart';
import 'detail/detail_product.dart';
import '../components/custom_card_cashier.dart';
import '../components/custom_search_bar.dart';

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final localProducts = await _localStorageService.getProducts();
      setState(() {
        _products = localProducts;
        _filteredProducts = localProducts;
      });
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

  void _searchProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products
          .where((product) => product.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier Product List'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[50],
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onSearch: _searchProducts,
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? Center(child: Text('No products found.'))
                      : GridView.builder(
                          padding: EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return CustomCardCashier(
                              title: product.title,
                              subtitle: '\$${product.price.toStringAsFixed(2)}',
                              imageUrl: product.image,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductPage(product: product),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
