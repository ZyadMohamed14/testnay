import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';

import '../../../core/dimensions.dart';
import '../../../di_container.dart';
import '../../../utill/styles.dart';

class AddToCartButtonWidget extends StatelessWidget {

  final double? width;
  final double? height;
  final Product product;

  const AddToCartButtonWidget({
    Key? key,
    this.width,
    this.height, required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLtr = Get.locale?.languageCode != 'ar';
    return BlocBuilder<CartCubit, CartState>(
  builder: (context, state) {

        int quantity =  context.read<CartCubit>().getProductQuantity(product.id!);
    return DecoratedBox(decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          offset: const Offset(0, 2),
          blurRadius: Dimensions.radiusExtraLarge,
          spreadRadius: Dimensions.radiusSmall,
        )
      ],
    ),
    child:  quantity == 0?  _buildAddButton(context):Container(),
    );
  },
);
  }

  Widget _buildAddButton(BuildContext context) {

    return Material(
      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => (){

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeExtraSmall),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: Dimensions.paddingSizeLarge),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text('add'.tr,
                style: rubikBold.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                )),
          ]),
        ),
      ),
    );
  }


  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 18,
        ),
      ),
    );
  }
}