import 'package:flutter/material.dart';
import 'package:health_care/components/all_product_skeleton.dart';
import 'package:health_care/components/categories_skeleton.dart';
import 'package:health_care/components/product_card_skeleton.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/home_screen/components/animated_banner.dart';
import 'package:health_care/screens/home_screen/components/all_product.dart';
import 'package:health_care/screens/home_screen/components/section_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'components/categories.dart';
import './components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';


class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> _refreshProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Xóa cache sản phẩm
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('products');

      // Gọi hàm fetchProducts để làm mới dữ liệu
      // await fetchProducts(context);
    } catch (e) {
      // Xử lý lỗi nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi làm mới dữ liệu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 20),
                const AnimatedBanner(),
                const SizedBox(height: 10),
                _isLoading
                    ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bạn đang tìm kiếm?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                5, // Số lượng skeleton cards muốn hiển thị
                                (index) => const CategoryCardSkeleton(),
                              ),
                            ),
                          ]
                      ),
                    )
                    : 
                    const Categories(),
                const SizedBox(height: 10),
                _isLoading
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SectionTitle(
                            title: "Sản Phẩm Mới Nhất",
                            press: () {},
                          ),
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              4, // Số lượng skeleton cards muốn hiển thị
                              (index) => const ProductCardSkeleton(),
                            ),
                          ),
                        ),
                      ],
                    )
                    : const PopularProducts(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 600,
                  child: _isLoading
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SectionTitle(
                                  title: "Tất Cả Sản Phẩm",
                                  press: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.builder(
                                itemCount: 8, // Số lượng skeleton cards muốn hiển thị
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 16,
                                ),
                                itemBuilder: (context, index) => const AllCardSkeleton(),
                              ),
                            ),
                          ),
                        ],
                      )
                      : const AllProducts(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
