import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testnay/refactoring/home/widget/product_card.dart';

import '../../../core/dimensions.dart';
import '../../../di_container.dart';
import '../../../utill/styles.dart';
import '../../config/configration_model.dart';



class ProductSection extends StatelessWidget {
  final List<Product> products;
  final ConfigModel configModel;
  final String title;

  ProductSection({super.key, required this.products,required this.configModel, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: Dimensions.paddingSizeSmall,
      ),
      child: Container(
        width: Dimensions.webScreenWidth,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(
                children: [
                  Text(
                    title,
                    style: rubikBold.copyWith(
                        color: context.isDarkMode ? null : Colors.white),
                  ),
                  const Spacer(),
                  Text('view_all'.tr),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250, // Adjust this height as needed
              child: ListView.builder(
                // physics: const ClampingScrollPhysics(),
                addAutomaticKeepAlives: true, // Preserves state
                addRepaintBoundaries: true, // Prevents unnecessary repaints
                cacheExtent: 2000,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    width: 160, // Set a fixed width for each item
                    child: ProductCardWidget(product: product,configModel: configModel,),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}