import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testnay/refactoring/config/config_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/home/cubit/banner/banner_cubit.dart';
import 'package:testnay/refactoring/home/cubit/product/latestproduct/latest_product_cubit.dart';
import 'package:testnay/refactoring/home/widget/banner_section.dart';
import 'package:testnay/refactoring/home/widget/chef_reco_section.dart';
import 'package:testnay/refactoring/home/widget/lates_products_section.dart';
import '../../core/helper/my_responsive_helper.dart';
import '../images.dart';
import 'cubit/product/popular/popular_products_cubit.dart';
import 'cubit/product/recommaned/recommended_products_cubit.dart';
import 'widget/category_section.dart';
import 'cubit/category/category_cubit.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  late ConfigModel configModel;
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MyResponsiveHelper.isDesktop();
    return BlocListener<ConfigCubit, ConfigState>(
      listener: (context, state) {
        if(state is ConfigLoaded){
          configModel = state.config;
        }
      },
      child: Scaffold(
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(title: Text("Nay")),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            // Trigger refresh of all content
            await context.read<BannerCubit>().fetchBanners();
            await context.read<CategoryCubit>().fetchCategories();

            // Add other refresh logic here if needed (e.g., for CategorySection)
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // Required for RefreshIndicator
            child: Column(
              children: [

                /// Banner Widget
                BlocBuilder<BannerCubit, BannerState>(
                  builder: (context, state) {
                    if (state is BannerLoading) {
                      return BannerShimmerWidget(
                          isWeb: MyResponsiveHelper.isDesktop());
                    } else if (state is BannerError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is BannerLoaded) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 60 : 15,
                        ),
                        child: BannerListWidget(banners: state.banners),
                      );
                    }
                    return Center(child: Text("No banners available"));
                  },
                ),
                SizedBox(height: 10,),

                /// Category Widget
                CategorySection(),
                BlocBuilder<PopularProductsCubit, PopularProductsState>(
                  builder: (context, state) {
                    if (state is PopularProductsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PopularProductsLoaded) {

                      return ProductSection(
                        title: 'local_eats'.tr,
                        configModel: configModel,
                        products: state.productModel.products!,);
                    } else if (state is PopularProductsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No data'));
                  },
                ),
                SizedBox(height: 20,),
                /// Chefs recommendation Section
                BlocBuilder<RecommendedProductsCubit, RecommendedProductsState>(
                  builder: (context, state) {
                    if (state is RecommendedProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RecommendedProductLoaded) {
                      return ChefsRecommendationSection(
                        configModel: configModel,
                        products: state.productModel.products!,);
                    } else if (state is RecommendedProductError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No data'));
                  },
                ),

              SizedBox(height: 20,),
                /// Lates  Section
              BlocBuilder<LatestProductCubit, LatestProductState>(
                builder: (context, state) {
                  if (state is LatestProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LatestProductLoaded) {

                    return ProductSection(
                      title:  'latest_item'.tr,
                      configModel: configModel,
                      products: state.productModel.products!,);
                  } else if (state is LatestProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No data'));
                },
              ),
                

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      placeholder:
          (context, url) =>
          Image.asset(
            placeholder.isNotEmpty ? placeholder : Images.placeholderImage,
            height: height,
            width: width,
            fit: fit,
          ),
      errorWidget:
          (context, url, error) =>
          Image.asset(
            placeholder.isNotEmpty ? placeholder : Images.placeholderImage,
            height: height,
            width: width,
            fit: fit,
          ),
    );
  }
}
