import 'package:flutter/foundation.dart';
import 'package:health_care/models/CartItem.dart';



class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  static const int exchangeRate = 24000;
  //Thêm sp vào cart 
  void addToCart(CartItem item) {
    // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
    bool found = false;
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].id == item.id) {
        _cartItems[i].quantity++;
        found = true;
        break;
      }
    }
    if (!found) {
      _cartItems.add(item);
    }
    notifyListeners();
  }
  //Xoá sp khỏi cart
  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  // cập nhập số lượng
  void updateQuantity(String id, int newQuantity) {
    CartItem? item = _cartItems.firstWhere((item) => item.id == id, orElse: () => CartItem(id: '0', name: '', price: 0.0, img: '', quantity: 0));
    if (item != null) {
      item.quantity = newQuantity;
      notifyListeners();
    }
  }
  // lấy tổng giá tiền
  double getTotalPrice() {
    double total = 0.0;
    _cartItems.forEach((item) {
      total += item.price * item.quantity;
    });
    return total;
  }
  double getTotalPriceInUSD() {
    return getTotalPrice() / exchangeRate;
  }
}