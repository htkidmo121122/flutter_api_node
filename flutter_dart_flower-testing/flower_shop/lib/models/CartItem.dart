class CartItem {
  final String id;
  final String name;
  final double price;
  final String img;
  int quantity;
  final int? discount;
  final int stockCount;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.img,
    required this.quantity,
    this.discount,
    required this.stockCount,
  });
}
