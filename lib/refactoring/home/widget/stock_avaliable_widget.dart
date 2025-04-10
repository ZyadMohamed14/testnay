import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/dimensions.dart';
import '../../../core/helper/product_helper.dart';
import '../../../di_container.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../splash/splash_screen.dart';

class StockAvailableWidget extends StatelessWidget{
  final bool isAvailable;
  final bool isAvailableInStock;
  const StockAvailableWidget({
    super.key,required this.isAvailable, required this.isAvailableInStock,
  });
  @override
  Widget build(BuildContext context) {
    return !isAvailableInStock|| !isAvailable ? Positioned.fill(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const CustomAssetImageWidget(Images.clockSvg, color: Colors.white, width: 14, height: 14),

          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Flexible(child: Text(
            !isAvailable ? 'not_available'.tr : 'stock_out'.tr, textAlign: TextAlign.center,
            style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          )),
        ]),
      )),
    )) : const SizedBox();
  }

}