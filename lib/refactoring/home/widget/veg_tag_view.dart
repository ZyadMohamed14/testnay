import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

import '../../../core/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../splash/splash_screen.dart';

class VegTagView extends StatelessWidget {
  final Product? product;
  final ConfigModel configModel;

  const VegTagView({this.product, required this.configModel});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: configModel.isVegNonVegActive!,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: CustomAssetImageWidget(
                  Images.getImageUrl('${product!.productType}'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(
                '${product!.productType}'.tr,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 