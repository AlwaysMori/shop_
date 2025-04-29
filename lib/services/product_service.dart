import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'https://fakestoreapi.com/products';

//1.(Mengambil data produk dari API)
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

//2.(Kirim data produk baru ke API POST /products)
  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Parse the response body to create a Product object
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Product.fromJson(responseData);
    } else {
      print('Failed to add product: ${response.body}'); // Log the error response
      throw Exception('Failed to add product');
    }
  }
  
//3.Menggunakan PUT ke endpoint /products/:id untuk update data.
  Future<void> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      print('Failed to update product: ${response.body}'); // Log the error response
      throw Exception('Failed to update product');
    }
  }

//4.Menggunakan DELETE ke endpoint /products/:id untuk menghapus data.
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      print('Failed to delete product: ${response.body}'); // Log the error response
      throw Exception('Failed to delete product');
    }
  }
}
