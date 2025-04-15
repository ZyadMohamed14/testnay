import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/core/helper/price_conventer_helper.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';
import 'package:testnay/refactoring/home/widget/quantity_button.dart';
import 'package:testnay/refactoring/product/product_cubit.dart';
import 'package:testnay/refactoring/cart/cart_bottom_sheet.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

import '../../../core/dimensions.dart';
import '../../../core/widget/custome_snakbar_.dart';
import '../../../di_container.dart';
import '../../../utill/styles.dart';

class AddToCartButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Product product;
  final ConfigModel configModel;

  const AddToCartButtonWidget({
    Key? key,
    this.width,
    this.height,
    required this.product, required this.configModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLtr = Get.locale?.languageCode != 'ar';
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();
        int quantity = cartCubit.getProductQuantity(product.id!);
        bool isProductInCart = cartCubit.isProductInCart(product.id!);

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: Dimensions.radiusExtraLarge,
                spreadRadius: Dimensions.radiusSmall,
              ),
            ],
          ),
          child: isProductInCart
            ? _buildQuantityButton(context: context, quantity: quantity)
            : _buildAddButton(context),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        final cartCubit = context.read<CartCubit>();

        // Create a new cart model with quantity 1 and add it directly
        double? price = product.price;
        double discountedPrice = PriceConverterHelper.convertWithDiscount(
          price,
          product.discount,
          product.discountType,
        ) ?? price!;

        CartModel cartModel = CartModel(
          price!,
          discountedPrice,
          [], // variations
          (price - discountedPrice), // discount amount
          1, // always start with quantity 1
          0, // tax
          [], // addons
          product,
          [], // variations
        );

        // Add to cart - if product already exists, CartCubit will handle merging
        cartCubit.addToCart(cartModel);

        // Show success notification
        showCustomSnackBarHelper('${product.name} ${'quantity_updated'.tr}', isError: false);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: Container(
          width: 75,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: Dimensions.paddingSizeLarge,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'add'.tr,
                style: rubikBold.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required int quantity,
  }) {
    final cartCubit = context.read<CartCubit>();

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (quantity > 1) {
                  // Directly set new quantity using CartModel with exact quantity
                  _setExactQuantity(context, quantity - 1);

                  // Show quantity updated notification
                  showCustomSnackBarHelper('${product.name} ${'quantity_decreased'.tr}', isError: false);
                } else {
                  // Find item index for removal
                  int itemIndex = -1;
                  for (int i = 0; i < cartCubit.cartItems.length; i++) {
                    if (cartCubit.cartItems[i].product!.id == product.id) {
                      itemIndex = i;
                      break;
                    }
                  }

                  if (itemIndex >= 0) {
                    // Remove from cart if quantity would be 0
                    cartCubit.removeFromCart(cartCubit.cartItems[itemIndex], itemIndex);

                    // Show removed notification
                    showCustomSnackBarHelper('${product.name} ${'removed_from_cart'.tr}', isError: true);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: const Icon(Icons.remove, size: 18, color: Colors.white),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                quantity.toString(),
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                // Directly set new quantity
                _setExactQuantity(context, quantity + 1);

                // Show quantity updated notification
                showCustomSnackBarHelper('${product.name} ${'quantity_increased'.tr}', isError: false);
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to set an exact quantity
  void _setExactQuantity(BuildContext context, int newQuantity) {
    final cartCubit = context.read<CartCubit>();
    
    // Call the proper method on the cubit
    cartCubit.setExactQuantity(product.id!, newQuantity);
    
    // Show appropriate notification based on quantity change
    if (cartCubit.getProductQuantity(product.id!) < newQuantity) {
      showCustomSnackBarHelper('${product.name} ${'quantity_increased'.tr}', isError: false);
    } else {
      showCustomSnackBarHelper('${product.name} ${'quantity_decreased'.tr}', isError: false);
    }
  }
}
