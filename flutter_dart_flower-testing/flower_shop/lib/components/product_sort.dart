import 'package:flutter/material.dart';
import 'package:health_care/models/Product.dart';

class ProductSorter extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onSorted;

  const ProductSorter({required this.products, required this.onSorted, Key? key}) : super(key: key);

  @override
  _ProductSorterState createState() => _ProductSorterState();
}

class _ProductSorterState extends State<ProductSorter> {
  String _sortOption = 'default';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _sortOption = value;
        });
        List<Product> sortedProducts = List.from(widget.products);
        if (_sortOption == 'price_asc') {
          sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        } else if (_sortOption == 'price_desc') {
          sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        }
        widget.onSorted(sortedProducts);
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 'default',
            child: Text('Mới Nhất'),
          ),
          const PopupMenuItem(
            value: 'price_asc',
            child: Text('Giá: Thấp Đến Cao'),
          ),
          const PopupMenuItem(
            value: 'price_desc',
            child: Text('Giá: Cao Đến Thấp'),
          ),
        ];
      },
      icon: const Icon(Icons.sort, color: Color.fromARGB(255, 255, 106, 0),),
    );
  }
}
