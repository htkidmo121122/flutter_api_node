// animated_banner.dart
import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedBanner extends StatefulWidget {
  const AnimatedBanner({super.key});

  @override
  _AnimatedBannerState createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<AnimatedBanner> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Cách đều 2 bên 16 pixels
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _controller,
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // Khoảng cách giữa các hình ảnh
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Bo tròn các góc
                child: Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
