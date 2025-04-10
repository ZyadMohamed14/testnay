import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';

import '../../app_constants.dart';
import '../../core/dimensions.dart';
import '../../core/helper/date_converter_helper.dart';
import '../../core/helper/price_conventer_helper.dart';
import '../../core/helper/product_helper.dart';
import '../../di_container.dart';
import '../../utill/styles.dart';
import '../home/home_screen.dart';
import '../home/widget/product_card.dart';
import 'cart_repo.dart';

class CartBottomSheetWidget extends StatelessWidget {
  final Product product;

  const CartBottomSheetWidget({super.key, required this.product});

  void showCartBottomSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        int quantity = context.read<CartCubit>().getProductQuantity(product.id!);
        bool isArabicLanguage = Get.locale?.languageCode == 'ar';
        ({double? price, List<
            Variation>? variatins}) productBranchWithPrice = ProductHelper
            .getBranchProductVariationWithPrice(product);
        List<Variation>? variationList = productBranchWithPrice.variatins;
        double? price = productBranchWithPrice.price;
        double variationPrice = 0;
        double? discount = product.discount;
        String? discountType = product.discountType;
        double priceWithDiscount = PriceConverterHelper.convertWithDiscount(
            price, discount, discountType)!;
        double addonsCost = 0;
        // double addonsTax = 0;
        List<AddOn> addOnIdList = [];
        List<AddOns> addOnsList = [];

        double priceWithAddonsVariation = addonsCost +
            (PriceConverterHelper.convertWithDiscount(
                variationPrice + price!, discount, discountType)! * quantity);
        double priceWithAddonsVariationWithoutDiscount = ((price + variationPrice) * quantity) + addonsCost;
        double priceWithVariation = price + variationPrice;
        bool isAvailable = DateConverterHelper.isAvailable(
            product.availableTimeStarts!, product.availableTimeEnds!);

        CartModel cartModel = CartModel(
          priceWithVariation,
          priceWithDiscount,
          [],
          (priceWithVariation - PriceConverterHelper.convertWithDiscount( priceWithVariation, discount, discountType)!),
          quantity,
          (priceWithVariation  - PriceConverterHelper.convertWithDiscount( priceWithVariation, product.tax, product.taxType)!),
          addOnIdList, product,
        [],
        );

        return BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  /// for image and
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          image:
                          '${AppConstants.baseProductssImageUrl}${product
                              .image}',
                          height: 150,
                          width: 220,
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// Wish Button
                      Positioned(
                        right:
                        !isArabicLanguage
                            ? Dimensions.paddingSizeSmall
                            : null,
                        left:
                        isArabicLanguage ? Dimensions.paddingSizeSmall : null,
                        child: WishButtonWidget(product: product),
                      ),

                      /// product Description
                      Positioned(
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(
                              product.name!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: rubikSemiBold,
                            ),
                            subtitle: RatingBarWidget(
                                rating: product.rating!.isNotEmpty ? product
                                    .rating![0].average! : 0.0, size: 15),

                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget should contain the trigger for showing the bottom sheet
    return ElevatedButton(
      onPressed: () => showCartBottomSheet(context, product),
      child: const Text('Show Cart'),
    );
  }
}
