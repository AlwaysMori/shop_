import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Product> _products = [];
  bool _isLoading = false;
  List<Product> _cart = [];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  List<Product> get cart => _cart;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final localProducts = await _localStorageService.getProducts();
      if (localProducts.isNotEmpty) {
        _products = localProducts;
      } else {
        // Fetch from API if local storage is empty or fails
        final fetchedProducts = await _productService.fetchProducts();
        _products = fetchedProducts;
        await _localStorageService.saveProducts(_products);
      }
    } catch (e) {
      debugPrint(        'Failed to load products: $e'      );
      // Fallback to API fetch if local storage fails
      try {
        final fetchedProducts = await _productService.fetchProducts();
        _products = fetchedProducts;
        await _localStorageService.saveProducts(_products);
      } catch (apiError) {
        debugPrint(          'Failed to fetch products from API: $apiError'        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final addedProduct = await _productService.addProduct(product);

      // Pastikan produk memiliki ID unik
      if (_products.any((p) => p.id == addedProduct.id)) {
        addedProduct.id = DateTime.now().millisecondsSinceEpoch; // Tetapkan ID unik jika duplikat
      }

      _products.add(addedProduct);
      await _localStorageService.saveProducts(_products);
      notifyListeners();
    } catch (e) {
      debugPrint(        'Failed to add product: $e'      );
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _productService.updateProduct(product.id, product);

      // Perbarui produk berdasarkan ID
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

      // Hapus produk berdasarkan ID
      _products.removeWhere((product) => product.id == id);
      await _localStorageService.saveProducts(_products);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to delete product: $e');
    }
  }

  Future<void> addToCart(Product product) async {
    _cart.add(product);
    await _localStorageService.saveCart(_cart);
    notifyListeners();
  }

  Future<void> loadCart() async {
    try {
      _cart = await _localStorageService.getCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load cart: $e');
    }
  }

  Future<void> saveCart(List<Product> cart) async {
    try {
      await _localStorageService.saveCart(cart);
      _cart = cart;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to save cart: $e');
    }
  }

  Future<void> deleteFromCart(Product product) async {
    _cart.removeWhere((item) => item.id == product.id);
    await _localStorageService.saveCart(_cart);
    notifyListeners();
  }
}
