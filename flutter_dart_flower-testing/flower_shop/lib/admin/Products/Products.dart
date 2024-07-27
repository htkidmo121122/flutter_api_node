import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:health_care/admin/Products/product_service.dart';
import 'package:health_care/models/Product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
  static String routeName = "/products_admin";
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  bool isLoading = false;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      products = await _productService.fetchProducts();
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showAddProductDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final imageController = TextEditingController();
    final stockController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image (Base64)'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Stock Count'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final product = Product(
                    id: DateTime.now().toString(), // Generate a unique ID
                    title: titleController.text,
                    description: descriptionController.text,
                    price: double.parse(priceController.text),
                    category: categoryController.text,
                    images: imageController.text,
                    countInStock: int.parse(stockController.text),
                    rating: 0, // Set default value or add input field
                    discount: 0, // Set default value or add input field
                  );
                  await _productService.addProduct(product);
                  await fetchProducts();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error adding product: $e');
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Uint8List decodeBase64(String base64String) {
    return base64Decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản Phẩm'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: showAddProductDialog,
          // ),
        ],
      ),
      //],
      //),
      body: isLoading
          ? Center(child: Image.asset('assets/images/loadingflower.gif'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.memory(decodeBase64(product.images)),
                  title: Text(product.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${product.price}đ'),
                      Text('Stock: ${product.countInStock}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: () {
                          // Implement edit functionality here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: () {
                          // deleteProduct(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
