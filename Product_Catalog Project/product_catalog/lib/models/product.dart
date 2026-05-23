class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String iconName; // icon name instead of image URL
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.price,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      iconName: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
