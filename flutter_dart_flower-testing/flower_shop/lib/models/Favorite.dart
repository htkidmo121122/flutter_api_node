class Favorite {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;

  Favorite({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    String base64Image = json['product']['image'].split(',').last;
    return Favorite(
      id: json['_id'],
      userId: json['user'],
      productId: json['product']['_id'],
      productName: json['product']['name'],
      productPrice: json['product']['price'].toDouble(),
      productImage: base64Image,
    );
  }
}