import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final localProducts = await _localStorageService.getProducts();
      if (localProducts.isNotEmpty) {
        _products = localProducts;
      } else {
        final fetchedProducts = await _productService.fetchProducts();
        _products = fetchedProducts;
        await _localStorageService.saveProducts(_products);
      }
    } catch (e) {
      debugPrint('Failed to load products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final addedProduct = await _productService.addProduct(product);
      _products.add(addedProduct);
      await _localStorageService.saveProducts(_products);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _productService.updateProduct(product.id, product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        await _localStorageService.saveProducts(_products);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      await _localStorageService.saveProducts(_products);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to delete product: $e');
    }
  }
}
