import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

import '../../app_constants.dart';
import '../../core/dimensions.dart';
import '../../core/helper/date_converter_helper.dart';
import '../../core/helper/price_conventer_helper.dart';
import '../../core/helper/product_helper.dart';
import '../../di_container.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';
import '../home/home_screen.dart';
import '../home/widget/product_card.dart';
import '../splash/splash_screen.dart';
import 'cart_repo.dart';

class CartBottomSheetWidget extends StatelessWidget {
  final bool isInCart;
  final Product product;
  final ConfigModel configModel;

  CartBottomSheetWidget({
    super.key,
    required this.isInCart,
    required this.configModel,
    required this.product,
  });

  void showCartBottomSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final cartCubit = context.read<CartCubit>();
        int quantity = cartCubit.getProductQuantity(product.id!);
        bool isInCart = cartCubit.isProductInCart(product.id!);
        bool isArabicLanguage = Get.locale?.languageCode == 'ar';
        ({double? price, List<Variation>? variatins}) productBranchWithPrice =
            ProductHelper.getBranchProductVariationWithPrice(product);
        List<Variation>? variationList = productBranchWithPrice.variatins;
        double? price = productBranchWithPrice.price;
        double variationPrice = 0;
        double? discount = product.discount;
        String? discountType = product.discountType;
        double priceWithDiscount =
            PriceConverterHelper.convertWithDiscount(
              price,
              discount,
              discountType,
            )!;
        double addonsCost = 0;
        // double addonsTax = 0;
        List<AddOn> addOnIdList =
            isInCart ? cartCubit.getCartModel(product.id!)!.addOnIds! : [];
        List<AddOns> addOnsList = product.addOns??[];

        double priceWithAddonsVariation =
            addonsCost +
            (PriceConverterHelper.convertWithDiscount(
                  variationPrice + price!,
                  discount,
                  discountType,
                )! *
                quantity);
        double priceWithAddonsVariationWithoutDiscount =
            ((price + variationPrice) * quantity) + addonsCost;
        double priceWithVariation = price + variationPrice;
        bool isAvailable = DateConverterHelper.isAvailable(
          product.availableTimeStarts!,
          product.availableTimeEnds!,
        );

        CartModel? cartModel =
            isInCart
                ? cartCubit.getCartModel(product.id!)
                : CartModel(
                  priceWithVariation,
                  priceWithDiscount,
                  [],
                  (priceWithVariation -
                      PriceConverterHelper.convertWithDiscount(
                        priceWithVariation,
                        discount,
                        discountType,
                      )!),
                  quantity,
                  (priceWithVariation -
                      PriceConverterHelper.convertWithDiscount(
                        priceWithVariation,
                        product.tax,
                        product.taxType,
                      )!),
                  addOnIdList,
                  product,
                  [],
                );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// for image ,  add to favourite Button  and product name ,rating , price
                Stack(
                  children: [
                    /// image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        image:
                            '${AppConstants.baseProductssImageUrl}${product.image}',
                        height: 150,
                        width: 220,
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// fav button
                    Positioned(
                      right:
                          !isArabicLanguage
                              ? Dimensions.paddingSizeSmall
                              : null,
                      left:
                          isArabicLanguage
                              ? Dimensions.paddingSizeSmall
                              : null,
                      child: WishButtonWidget(product: product),
                    ),

                    /// product name ,rating , price
                    Positioned(
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
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
                            rating:
                                product.rating!.isNotEmpty
                                    ? product.rating![0].average!
                                    : 0.0,
                            size: 15,
                          ),
                          leading: Text(
                            PriceConverterHelper.convertPrice(
                              priceWithAddonsVariationWithoutDiscount,
                              configModel,
                            ),
                            style: rubikSemiBold.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Product Description
                ProductDescription(
                  product: product,
                  configModel: configModel,
                ),

                /// for Addons
                if (product.addOns!.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withOpacity(0.5),
                          blurRadius: Dimensions.radiusDefault,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(
                      Dimensions.paddingSizeSmall,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: product.addOns!.length,
                      itemBuilder: (context, index) {
                        final addOn = product.addOns![index];
                        return AddonsItem(addOns: addOn, cartModel: cartModel!,);
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],

                /// for bottom Total amount, quantity, & add to cart button section
                Row(children: [
                  Text('total'.tr, style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                  Text(
                    PriceConverterHelper.convertPrice(priceWithAddonsVariation,configModel),
                    style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ],)
              ],
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
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('description'.tr, style: rubikSemiBold),

                product.productType != null
                    ? _VegTagView(product: product, configModel: configModel)
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ],
        )
        : const SizedBox();
  }
}

class _VegTagView extends StatelessWidget {
  final Product? product;
  final ConfigModel configModel;

  const _VegTagView({this.product, required this.configModel});

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

class AddonsItem extends StatefulWidget {
  final AddOns addOns;
  final CartModel cartModel;

  const AddonsItem({super.key, required this.addOns, required this.cartModel});

  @override
  State<AddonsItem> createState() => _AddonsItemState();
}

class _AddonsItemState extends State<AddonsItem> {
  bool isChecked= false;
  @override
  Widget build(BuildContext context) {
   // bool isChecked = context.read<CartCubit>.isAddOnSelected(productId, addOnId);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('addons'.tr, style: rubikSemiBold),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ListTile(
            leading: Checkbox(
              // value: context.read<CartCubit>().isAddOnSelected(
              //   widget.cartModel.product!.id!,
              //   widget.addOnId,
              // ),\
              value: isChecked,
              activeColor: Theme.of(context).primaryColor,
              checkColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              // side: BorderSide(color: productProvider.addOnActiveList[i]
              //     ? Colors.transparent : Theme.of(context).hintColor, width: 1),
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  final cubit = context.read<CartCubit>();
                  cubit.updateTotalPrice(widget.addOns.price!);


              }},
              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
            ),
          ),
        ],
      ),
    );
  }
}
/*
 onChanged: (bool? newValue) {
                if (newValue != null) {
                  final cubit = context.read<CartCubit>();

                  // Find the cart item index
                  final itemIndex = cubit.cartItems.indexWhere(
                    (item) => item.product?.id == widget.cartModel.product?.id,
                  );

                  if (itemIndex != -1) {
                    // Ensure addOnIds list exists
                    final cartItem = cubit.cartItems[itemIndex];
                    cartItem.addOnIds ??= [];

                    final addOns = cubit.cartItems[itemIndex].addOnIds!;
                    final existingIndex = addOns.indexWhere(
                      (a) => a.id == widget.addOnId,
                    );

                    if (newValue) {
                      // Add or update the add-on
                      if (existingIndex == -1) {
                        addOns.add(
                          AddOn(id: widget.addOnId, quantity: 1, isSelected: true),
                        );
                      } else {
                        addOns[existingIndex].isSelected = true;
                      }
                    } else {
                      // Remove the add-on
                      if (existingIndex != -1) {
                        addOns.removeAt(existingIndex);
                      }
                    }

                    // Trigger update
                    cubit.addToCart(cubit.cartItems[itemIndex]);
                  }
                }
              },
 */