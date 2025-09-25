import 'dart:async';
import 'package:flutter/material.dart';

class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({super.key});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> banners = [
    {
      'image':
          'https://res.cloudinary.com/dshhlawvf/image/upload/v1751198514/cover_ruang_tamu_mionimalis_rtw6mi.jpg',
      'title': 'Celebrate The Season With Us!',
      'desc': 'Get discounts up to 75% for furniture & decoration',
    },
    {
      'image':
          'https://res.cloudinary.com/dshhlawvf/image/upload/v1751198115/page__en_us_15724034250_ubzv1z.jpg',
      'title': 'Big Sale is Coming!',
      'desc': 'Limited time offer only this weekend!',
    },
    {
      'image':
          'https://res.cloudinary.com/dshhlawvf/image/upload/v1751198643/63b3b3bbe72ad_xxdfqu.jpg',

      'title': 'Modern Living Collection',
      'desc': 'Update your space with trending styles',
    },
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 199,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Stack(
                children: [
                  Positioned(
                    top: -25,
                    left: 0,
                    child: Image.network(
                      banner['image']!,
                      width: MediaQuery.of(context).size.width,
                      height: 251,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xF0156651),
                          Color(0xAB156651),
                          Color(0x00156651),
                        ],
                        stops: [0.2642, 0.4502, 0.6612],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 31,
                    child: SizedBox(
                      width: 178,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Manrope',
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['desc']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Manrope',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Aksi tombol Shop Now
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF156651),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(42),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Shop Now',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? const Color(0xFF156651)
                        : const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
