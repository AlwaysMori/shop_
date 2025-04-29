import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/local_storage_service.dart';
import 'detail/detail_product.dart';
import '../components/custom_card_cashier.dart';

class CashierPage extends StatefulWidget {
  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  List<Product> _products = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier Product List'),
        backgroundColor: Colors.blue, // Warna biru untuk AppBar
      ),
      body: Container(
        color: Colors.blue[50], // Latar belakang putih kebiruan
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? Center(child: Text('No products available.'))
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dua kolom
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 4, // Rasio aspek untuk kartu
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return CustomCardCashier(
                        title: product.title,
                        subtitle: '\$${product.price.toStringAsFixed(2)}',
                        imageUrl: product.image,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailProductPage(product: product),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
