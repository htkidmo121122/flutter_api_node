class CartItem {
  final int id;
  final String name;
  final double price;
  final String img;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.img,
    required this.quantity,
  });
}
