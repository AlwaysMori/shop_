import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../services/local_storage_service.dart';
import 'detail/detail_product.dart';
import '../components/custom_card_cashier.dart';
import '../components/custom_search_bar.dart';
import '../auth/login_page.dart';
import '../home/cashier_total/total_payment.dart';

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
    Provider.of<ProductProvider>(context, listen: false).loadCart();
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

  void _addToCart(Product product) {
    Provider.of<ProductProvider>(context, listen: false).addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Cashier Product List'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue[50],
          child: Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                onSearch: _searchProducts,
              ),
              Flexible(
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
                              childAspectRatio: 4 / 6,
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
                                onAddToCart: () => _addToCart(product),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TotalPaymentPage(),
              ),
            ),
            backgroundColor: Colors.blue,
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
          if (Provider.of<ProductProvider>(context).cart.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${Provider.of<ProductProvider>(context).cart.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
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
