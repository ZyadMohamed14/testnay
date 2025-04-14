import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnay/refactoring/config/config_cubit.dart';
import 'package:testnay/refactoring/home/cubit/product/latestproduct/latest_product_cubit.dart';
import 'package:testnay/refactoring/home/cubit/product/popular/popular_products_cubit.dart';

import 'package:testnay/refactoring/home/cubit/product/recommaned/recommended_products_cubit.dart';
import 'package:testnay/refactoring/home/data/product_repository.dart';

import '../../di_container.dart';
import '../../refactoring/home/cubit/banner/banner_cubit.dart';
import '../../refactoring/home/cubit/category/category_cubit.dart';
import '../../refactoring/home/data/banner_repository.dart';
import '../../refactoring/home/data/category_repository.dart';
import '../../refactoring/home/home_screen.dart';
import '../../refactoring/netwrok/network_cubit.dart';
import '../../refactoring/noconections/no_connections_screen.dart';
import '../../refactoring/splash/splash_screen.dart';
import '../../refactoring/test.dart';

class Routes {
  static const String splashScreen = '/splash';
  static const String noInternetContectesdScreen = '/no_internet';

  // static const String splashAnimationScreen = '/splash_animation';
  static const String languageScreen = '/select-language';
  static const String onBoardingScreen = '/on_boarding';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String verify = '/verify';
  static const String forgotPassScreen = '/forgot-password';
  static const String createNewPassScreen = '/create-new-password';
  static const String createAccountScreen = '/create-account';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String update = '/update';
  static const String dashboardScreen = '/main';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String setMenuScreen = '/set-menu';
  static const String categoryScreen = '/category';
  static const String notificationScreen = '/notification';
  static const String checkoutScreen = '/checkout';
  static const String paymentScreen = '/payment';
  static const String orderSuccessScreen = '/order-completed';
  static const String orderDetailsScreen = '/order-details';
  static const String rateScreen = '/rate-review';
  static const String orderTrackingScreen = '/order-tracking';
  static const String profileScreen = '/profile';
  static const String addressScreen = '/address';
  static const String mapScreen = '/map';
  static const String addAddressScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String chatScreen = '/messages';
  static const String couponScreen = '/coupons';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String imageDialog = '/image-dialog';
  static const String menuScreenWeb = '/menu_screen_web';
  static const String homeScreen = '/home';
  static const String orderWebPayment = '/order-web-payment';
  static const String popularItemRoute = '/POPULAR_ITEM_ROUTE';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String wallet = '/wallet-screen';
  static const String referAndEarn = '/refer_and_earn';
  static const String branchListScreen = '/branch-list';
  static const String productImageScreen = '/image-screen';
  static const String qrCategoryScreen = '/qr-category-screen';
  static const String loyaltyScreen = '/loyalty-screen';
  static const String orderSearchScreen = '/order-search';
  static const String branchScreen = '/branch-screen';
  static const String homeItem = '/home-item';
  static const String otpVerification = '/send-otp-verification';
  static const String otpRegistration = '/otp-registration';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //   case Routes.splashScreen:
      //     return MaterialPageRoute(builder: (_) => BlocProvider.value(
      // value: sl.get<ConfigCubit>()..loadConfig(),  // Using existing bloc instance
      //       child: SplashScreen(),
      //     ));

      case Routes.splashScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => NetworkCubit()..checkConnectivity(),
                child: SplashScreen(),
              ),
        );
      case 'test':
        return MaterialPageRoute(builder: (_) => const LanguageTestScreen());
      case Routes.noInternetContectesdScreen:
        return MaterialPageRoute(builder: (_) => NoInternetScreen());
      case 'test1':
        return MaterialPageRoute(builder: (_) => const Screen1());
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (_) => BannerCubit(
                          bannerRepository: sl<BannerRepository>(),
                        )..fetchBanners(),
                  ),
                  BlocProvider(
                    create:
                        (_) => CategoryCubit(
                          categoryRepository: sl<CategoryRepository>(),
                        )..fetchCategories(),
                  ),
                  BlocProvider(
                    create:
                        (_) => LatestProductCubit(
                          productRepository: sl<ProductRepository>(),
                        )..fetchLatestProducts(),
                  ),
                  BlocProvider(
                    create:
                        (_) => RecommendedProductsCubit(
                          productRepository: sl<ProductRepository>(),
                        )..fetchRecommendedProducts(),
                  ),

                  BlocProvider(
                    create:
                        (_) => PopularProductsCubit(
                      productRepository: sl<ProductRepository>(),
                    )..fetchLatestProducts(),
                  ),
                ],
                child: HomeScreen(),
              ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Center(child: Text('no route defined')),
        );
    }
  }
}
