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
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch, // Gunakan timestamp jika ID null
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
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
