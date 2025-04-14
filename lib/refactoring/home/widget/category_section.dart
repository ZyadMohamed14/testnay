import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testnay/app_constants.dart';
import 'package:testnay/refactoring/home/cubit/category/category_cubit.dart';
import '../../../core/dimensions.dart';
import '../../../core/helper/my_responsive_helper.dart';
import '../../../di_container.dart';
import '../../../utill/styles.dart';
import '../../cate_model.dart';
import '../data/category_repository.dart';


class CategorySection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(

      builder: (context, state) {
        if (state is CategoryLoading) {
          return CategoryShimmerWidget();
        } else if (state is CategoryError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CategoryLoaded) {
          return _buildCategoryList(state.categories,context);
        }
        return Center(child: Text("No categories available"));
      },
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories,BuildContext context) {
    return Container(
      //color: Theme.of(context).cardColor,
      height: 160, // Adjust height as needed
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'category'.tr,
            style: rubikBold.copyWith(
              color:
              MyResponsiveHelper.isDesktop()
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
              fontSize:20,
            ),
          ),
          SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular category image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: '${AppConstants.baseCategoriesImageUrl}${category.image}',
                placeholder: (context, url) =>
                    Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.category, color: Colors.grey.shade400),
                    ),
                errorWidget: (context, url, error) =>
                    Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                          Icons.broken_image, color: Colors.grey.shade400),
                    ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          // Category name
          Container(
            width: 70,
            child: Text(
              category.name ?? 'Unnamed',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryShimmerWidget extends StatelessWidget {
  const CategoryShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6, // Number of shimmer placeholders
        itemBuilder: (_, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 70,
                    height: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}