class Product {
  final String name;
  final String description;
  final double price;
  final String images;
  final double discount;
  final String sellerId; // Add sellerId field

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.discount,
    required this.sellerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'stock': discount,
      'sellerId': sellerId,
    };
  }
}
