import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testnay/refactoring/cart/widgets/cart_item.dart';
import 'package:testnay/refactoring/config/config_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

import '../../core/dimensions.dart';
import '../../core/helper/my_responsive_helper.dart';
import '../../core/widget/custome_appbar.dart';
import '../../core/widget/delivert_time_widget.dart';
import '../../utill/styles.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(context: context, title: 'cart'.tr, isBackButtonExist: !MyResponsiveHelper.isMobile()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DeliveryTimeEstimationWidget(),
            const SizedBox(height: 10,),
            /// cart items list
            Padding(padding: EdgeInsets.symmetric(horizontal: MyResponsiveHelper.isDesktop() ? 0 : Dimensions.paddingSizeSmall),
                child: TitleWidget(

                  isShowTrailingIcon: true,
                  trailingIcon: const Icon(Icons.swipe),
                  //leadingIcon: const Icon(Icons.swipe,),
                  title: 'swipe_to_delete'.tr,
                )),
            const SizedBox(height: 10,),
            CartListWidget()
          ],
        ),
      ),
    );
  }

}
class TitleWidget extends StatelessWidget {
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isShowLeadingIcon;
  final bool isShowTrailingIcon;
  final String? title;
  final String? subTitle;
  final Function? onTap;

  const TitleWidget({
    super.key, required this.title, this.onTap, this.subTitle,
    this.leadingIcon, this.isShowLeadingIcon = false, this.trailingIcon, this.isShowTrailingIcon = false,
  });

  @override
  Widget build(BuildContext context) {


    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Row(mainAxisSize: MainAxisSize.min, children: [
        if(isShowLeadingIcon && leadingIcon != null)...[
          const SizedBox(width: Dimensions.paddingSizeSmall),
          leadingIcon ?? const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeSmall),
        ],
        Text(title!, style: rubikBold.copyWith(color: context.isDarkMode ? null : Colors.white)),
      ]),

      if(isShowTrailingIcon && trailingIcon != null) trailingIcon!,

      if(onTap != null && !isShowTrailingIcon) InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            subTitle ?? 'view_all'.tr,
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.isDarkMode ? null : Colors.white),
          ),
        ),
      ),
    ]);
  }
}