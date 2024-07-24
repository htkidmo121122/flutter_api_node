import 'dart:convert';
import 'package:health_care/screens/details_screen/components/top_rounded_container.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/models/CartItem.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/provider/cart_provider.dart';
import 'package:health_care/screens/details_screen/components/comment_section.dart';
import 'package:health_care/screens/details_screen/components/product_description.dart';
import 'package:health_care/screens/details_screen/components/product_images.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfProductIsFavorite();
  }

  Future<void> _checkIfProductIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? accessToken = prefs.getString('access_token');

    if (userDataString == null) return;

    try {
      final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
      final product = args.product;
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final userId = userData['_id'];
      final productId = product.id;

      final url = Uri.parse('http://localhost:3001/api/favourite/check-favourite/$userId');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'productId': productId,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _isFavorite = jsonDecode(response.body)['isFavorite'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi kiểm tra yêu thích')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _addFavorite(String productId) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? accessToken = prefs.getString('access_token');

    if (userDataString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final userId = userData['_id'];

      final url = Uri.parse('http://localhost:3001/api/favourite/$userId');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'productId': productId,
        }),
      );
      print(response.body);
      if (response.statusCode == 201) {
        setState(() {
          _isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm Yêu Thích')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> removeFavorite(String productId) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? accessToken = prefs.getString('access_token');

    if (userDataString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final userId = userData['_id'];

      final url = Uri.parse('http://localhost:3001/api/favourite/$userId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'productId': productId,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa Yêu Thích')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = args.product;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_isFavorite) {
                removeFavorite(product.id);
              } else {
                _addFavorite(product.id);
              }
            },
            style: ElevatedButton.styleFrom(
            
              shadowColor: Colors.transparent,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ProductImages(product: product),
          TopRoundedContainer(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                ),
                const SizedBox(height: 10),
                CommentsSection(productId: product.id),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

              child: 
                ElevatedButton(
                  onPressed: () {
                    CartProvider cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    bool result = cartProvider.addToCart(CartItem(
                      id: product.id,
                      name: product.title,
                      price: product.price,
                      img: product.images,
                      quantity: 1,
                      discount: product.discount,
                      stockCount: product.countInStock,
                    ));
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã thêm vào giỏ hàng'),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/outofstock.gif',
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(height: 16),
                                const Text(
                                  'Sản phẩm đã hết hàng',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              
            ),
          ),
        ),
      
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
