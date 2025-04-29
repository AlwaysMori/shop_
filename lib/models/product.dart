//1.(Untuk parsing data JSON API menjadi objek Dart)
class Product {
  int id;
  String title;
  double price;
  String description;
  String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Default to 0 if id is null
      title: json['title'] ?? '', // Default to empty string if title is null
      price: (json['price'] ?? 0).toDouble(), // Default to 0.0 if price is null
      description: json['description'] ?? '', // Default to empty string
      image: json['image'] ?? '', // Default to empty string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
    };
  }
}
