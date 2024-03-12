class ProductSerialize {
  final String images;
  final String sellerId;
  final double price;
  final String name;
  final String description;
  final double stock;
  final String productId;

  ProductSerialize({
    required this.images,
    required this.sellerId,
    required this.price,
    required this.name,
    required this.description,
    required this.stock,
    required this.productId,
  });

  factory ProductSerialize.fromJson(Map<String, dynamic> json) {
    return ProductSerialize(
      images: json['images'],
      sellerId: json['sellerId'],
      price: json['price'].toDouble(),
      name: json['name'],
      description: json['description'],
      stock: json['stock'].toDouble(),
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images,
      'sellerId': sellerId,
      'price': price,
      'name': name,
      'description': description,
      'stock': stock,
      'productId': productId,
    };
  }
}
