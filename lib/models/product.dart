class Product {
  final String id;
  final String title;
  final String price;
  final String thumbnailPath;
  final String? description;
  final String? category;
  final List<String>? images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnailPath,
    this.description,
    this.category,
    this.images,
  });

  factory Product.fromFirestore(
      Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      title: data['name'] ?? '',
      price: data['price'].toString(),
      thumbnailPath: data['image'] ?? '',
      description: data['description'],
      category: data['category'],
      images: data['images'] != null
          ? List<String>.from(data['images'])
          : [],
    );
  }
}
