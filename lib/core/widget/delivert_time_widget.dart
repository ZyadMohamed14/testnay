import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../refactoring/config/config_cubit.dart';
import '../../refactoring/images.dart';
import '../../refactoring/splash/splash_screen.dart';
import '../../utill/dimensions.dart';
import '../../utill/styles.dart';
import '../helper/my_responsive_helper.dart';

class DeliveryTimeEstimationWidget extends StatelessWidget {
  const DeliveryTimeEstimationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final configModel = context.read<ConfigCubit>().configModel;
    final currantBranch = configModel!.branches![0];
    final bool isDesktop = MyResponsiveHelper.isDesktop();

    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      decoration: BoxDecoration(
        color: Color(0xFFFFBA08).withOpacity(0.07),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            const CustomAssetImageWidget(Images.restaurantLocationSvg, width: 16, height: 16),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text( currantBranch!.name??'main_branch'.tr, style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
            )),
          ]),


        ]),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Divider(color: Theme.of(context).primaryColor.withOpacity(0.2), height: Dimensions.paddingSizeLarge, thickness: 0.3),
        ),

        Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          const Align(alignment: Alignment.bottomLeft, child: CustomAssetImageWidget(
            Images.walkingSvg, width: 45, height: 45,
          )),

          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('estimate_delivery_time'.tr, style: rubikRegular.copyWith(
              fontSize: MyResponsiveHelper.isDesktop() ? Dimensions.fontSizeSmall : Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).hintColor,
            )),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text('${currantBranch.preparationTime ?? 0}${'min'.tr .toLowerCase()} - ${(currantBranch.preparationTime ?? 0) + 10}${'min'.tr}', style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: MyResponsiveHelper.isDesktop() ? FontWeight.w700 : FontWeight.w600,
            )),
          ]),

          const Align(alignment: Alignment.bottomRight, child: CustomAssetImageWidget(
            Images.drivingSvg, width: 45, height: 45,
          )),

        ])),

      ]),
    );
  }
}