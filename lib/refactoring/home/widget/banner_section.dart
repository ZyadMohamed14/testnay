import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/dimensions.dart';
import '../../../core/helper/my_responsive_helper.dart';
import '../../../di_container.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../home_screen.dart';

class BannerListWidget extends StatefulWidget {
  final List<BannerModel> banners;

  BannerListWidget({required this.banners});

  @override
  _BannerListWidgetState createState() => _BannerListWidgetState();
}

class _BannerListWidgetState extends State<BannerListWidget> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  // Function to start the auto-scrolling
  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Restart from the first banner
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Make sure to cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild screeeeeeeeeeeeeen');
    bool isWeb = MyResponsiveHelper.isWeb();
    return Container(
      height: isWeb ? 400 : 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'today_specials'.tr,
              style: rubikBold.copyWith(
                color:
                MyResponsiveHelper.isDesktop()
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontSize:
                MyResponsiveHelper.isDesktop()
                    ? Dimensions.fontSizeExtraLarge
                    : Dimensions.fontSizeDefault,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              // Add this
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  return BannerWidget(banner: widget.banners[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  final BannerModel banner;

  BannerWidget({required this.banner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the banner click event, like navigating to a product page
        print("Banner clicked: ${banner.title}");
      },
      child: MouseRegion(
        onEnter: (_) {
          // Change cursor to pointer when hovering over the image
          SystemMouseCursors.click;
        },
        child: Container(
          width: double.infinity,
          height: 250,
          child: CustomImageWidget(
            placeholder: Images.placeholderBanner,
            width: double.infinity,
            height:
            MyResponsiveHelper.isDesktop() || MyResponsiveHelper.isTab()
                ? double.infinity
                : 120,
            fit: BoxFit.fill,
            image: 'https://admin.naycity.org/storage/banner/${banner.image}',
          ),
        ),
      ),
    );
  }
}

class BannerShimmerWidget extends StatelessWidget {
  final bool isWeb;

  const BannerShimmerWidget({Key? key, required this.isWeb}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWeb ? 400 : 200,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(width: 150, height: 20, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (_, __) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: double.infinity,
                    height: isWeb ? 300 : 120,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}