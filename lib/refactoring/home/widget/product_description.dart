import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/home/widget/veg_tag_view.dart';

import '../../../core/dimensions.dart';
import '../../../utill/styles.dart';

class ProductDescription extends StatelessWidget {
  final Product product;
  final ConfigModel configModel;

  ProductDescription({
    super.key,
    required this.product,
    required this.configModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isLtr = Get.locale?.languageCode == 'en';
    return product.description != null && product.description!.isNotEmpty
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('description'.tr, style: rubikSemiBold),

                  product.productType != null
                      ? VegTagView(product: product, configModel: configModel)
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Align(
                alignment: isLtr ? Alignment.topLeft : Alignment.topRight,
                child: ReadMoreText(
                  product.description ?? '',
                  trimLines: 1,
                  trimCollapsedText: 'show_more'.tr,
                  trimExpandedText: 'show_less'.tr,
                  style: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                  moreStyle: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                  lessStyle: rubikRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ),
            ],
          ),
        )
        : const SizedBox();
  }
} 