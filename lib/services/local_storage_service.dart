import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class LocalStorageService {
  static const String _productsKey = 'products';

  Future<void> saveProducts(List<Product> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(products.map((product) => product.toJson()).toList());
    await prefs.setString(_productsKey, jsonString);
  }

  Future<List<Product>> getProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_productsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
