import 'package:flutter/foundation.dart';
import 'package:health_care/models/CartItem.dart';



class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  static const int exchangeRate = 24000;
  //Thêm sp vào cart 
  bool addToCart(CartItem item) {
    // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
    bool found = false;
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].id == item.id) {
        if (_cartItems[i].quantity < _cartItems[i].stockCount || 
        _cartItems[i].stockCount != 0) 
        {
          _cartItems[i].quantity++;
          notifyListeners();
          return true;
        } 
        else {
          // Báo hết hàng
          print('${item.name} đã hết hàng');
          return false;
        }
      }
    }
    if (!found) {
      _cartItems.add(item);
    }
    notifyListeners();
    return true;
  }
  //Xoá sp khỏi cart
  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  // cập nhập số lượng
  void updateQuantity(String id, int newQuantity) {
    CartItem? item = _cartItems.firstWhere((item) => item.id == id, orElse: () => CartItem(id: '0', name: '', price: 0.0, img: '', quantity: 0, stockCount: 0));
    if (item != null) {
      if (newQuantity <= item.stockCount) {
        item.quantity = newQuantity;
      } else {
        // Báo hết hàng
        print('Sản phẩm ${item.name} đã hết hàng');
        
      }
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
