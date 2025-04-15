import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/home/widget/addons_item.dart';
import 'package:testnay/refactoring/home/widget/product_description.dart';
import 'package:testnay/refactoring/home/widget/quantity_button.dart';
import 'package:testnay/refactoring/product/product_cubit.dart';
import 'package:testnay/di_container.dart';
import '../../app_constants.dart';
import '../../core/dimensions.dart';
import '../../core/helper/date_converter_helper.dart';
import '../../core/helper/price_conventer_helper.dart';
import '../../core/helper/product_helper.dart';
import '../../core/widget/custome_button_widget.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';
import '../home/home_screen.dart';
import '../home/widget/product_card.dart';
import '../splash/splash_screen.dart';
import 'cart_repo.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';
import 'package:testnay/core/widget/custome_snakbar_.dart';

class CartBottomSheetWidget extends StatelessWidget {
  final Product product;
  final ConfigModel configModel;

  CartBottomSheetWidget({
    super.key,
    required this.configModel,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    List<AddOns> dummyAddOnsList = [
      AddOns(
        id: 1,
        name: "Extra Cheese",
        price: 2.5,
        createdAt: "2025-01-01T12:00:00Z",
        updatedAt: "2025-01-02T12:00:00Z",
        tax: 5.0,
      ),
      AddOns(
        id: 2,
        name: "Spicy Sauce",
        price: 1.75,
        createdAt: "2025-01-03T14:00:00Z",
        updatedAt: "2025-01-04T14:00:00Z",
        tax: 4.5,
      ),
      AddOns(
        id: 3,
        name: "Bacon Bits",
        price: 3.0,
        createdAt: "2025-01-05T15:30:00Z",
        updatedAt: "2025-01-06T15:30:00Z",
        tax: 6.0,
      ),
      AddOns(
        id: 4,
        name: "Avocado",
        price: 2.0,
        createdAt: "2025-01-07T10:45:00Z",
        updatedAt: "2025-01-08T10:45:00Z",
        tax: 5.5,
      ),
      AddOns(
        id: 5,
        name: "Garlic Bread",
        price: 1.5,
        createdAt: "2025-01-09T08:20:00Z",
        updatedAt: "2025-01-10T08:20:00Z",
        tax: 4.0,
      ),
    ];
    product.addOns!.addAll(dummyAddOnsList);
    final cartCubit = context.read<CartCubit>();
    final productCubit = context.read<ProductCubit>();
    print("productCubit.discount.toString()");
    print(productCubit.discount.toString());

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
    List<AddOns> addOnsList = product.addOns ?? [];

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.height*0.75,
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// for image ,  add to favourite Button  and product name ,rating , price
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        /// image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomImageWidget(
                            image:
                                '${AppConstants.baseProductssImageUrl}${product.image}',
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// product name ,rating , price
                        Positioned(
                          bottom: -30,

                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).shadowColor.withOpacity(0.5),
                                    blurRadius: Dimensions.radiusDefault,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(16),
                                shape: BoxShape.rectangle,
                              ),
                              child: Material(
                                elevation: 0.0,
                                // Add elevation to create a shadow effect
                              //  borderRadius: BorderRadius.circular(16),
                                shape: RoundedRectangleBorder(
                               //   borderRadius: BorderRadius.circular(4),
                                ),
                                // Ensure the border radius matches
                                color: Colors.transparent,
                                // Use transparent to keep the DecoratedBox color
                                child: ListTile(
                                  title: Text(
                                    product.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikSemiBold,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      RatingBarWidget(
                                        rating:
                                            product.rating!.isNotEmpty
                                                ? product.rating![0].average!
                                                : 0.0,
                                        size: 15,
                                      ),
                                      Spacer(),
                                      if (productCubit.discount != null && productCubit.discount! > 0)
                                        Text(
                                          PriceConverterHelper.convertPrice(
                                            productCubit.originalPrice,
                                            configModel,
                                          ),
                                          style: rubikRegular.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      const SizedBox(width: 4), // Add space between values
                                      Text(
                                        PriceConverterHelper.convertPrice(
                                          productCubit.discount != null && productCubit.discount! > 0
                                              ? PriceConverterHelper.convertWithDiscount(
                                            productCubit.originalPrice,
                                            productCubit.discount,
                                            productCubit.discountType,
                                          )
                                              : productCubit.originalPrice,
                                          configModel,
                                        ),
                                        style: rubikBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            ),
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
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// Product Description
                    ProductDescription(
                      product: product,
                      configModel: configModel,
                    ),
                    const SizedBox(height: 30),

                    /// for Addons
                    if (product.addOns!.isNotEmpty) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withOpacity(0.5),
                            //  blurRadius: Dimensions.radiusDefault,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('addons'.tr, style: rubikSemiBold),
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall,
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index){
                                  return const SizedBox(height: Dimensions.paddingSizeSmall);
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: product.addOns!.length,
                                itemBuilder: (context, index) {
                                  final addOn = product.addOns![index];
                                  return AddonsItem(
                                    addOns: addOn,
                                    cartModel: cartModel!,
                                    configModel: configModel,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            /// for bottom Total amount, quantity, and  add to cart button section
            Row(
              children: [
                Text(
                  'total'.tr,
                  style: rubikSemiBold.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Spacer(),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    double currentTotalPrice = 0.0;
                    double originalTotalPrice = 0.0;
        
                    // Determine the current total price from the state
                    if (state is ProductQuantityUpdated) {
                      currentTotalPrice = state.totalPrice;
                      
                      // Calculate the original price without discount
                      originalTotalPrice = productCubit.originalPrice * productCubit.quantity;
                      
                      // Add addon prices to original price
                      for (var addon in productCubit.selectedAddon) {
                        if (addon.isSelected && addon.quantity != null && addon.price != null) {
                          originalTotalPrice += addon.quantity! * addon.price!;
                        }
                      }
                    }
                    
                    // Check if there's a discount
                    bool hasDiscount = productCubit.discount != null && productCubit.discount! > 0;
                    
                    return hasDiscount 
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Original price with strikethrough
                            Text(
                              PriceConverterHelper.convertPrice(
                                originalTotalPrice,
                                configModel,
                              ),
                              style: rubikRegular.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Discounted price
                            Text(
                              PriceConverterHelper.convertPrice(
                                currentTotalPrice,
                                configModel,
                              ),
                              style: rubikBold.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          PriceConverterHelper.convertPrice(
                            currentTotalPrice,
                            configModel,
                          ),
                          style: rubikSemiBold.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        );
                  },
                ),
              ],
            ),
        
            Row(
              children: [
                QuantityButton(),
                const SizedBox(width: Dimensions.paddingSizeLarge),
                Expanded(
                  child: CustomButtonWidget(
                    btnTxt: 'Add To Cart',
                    onTap: () {

        
                      // Get current product price with discount
                      double priceWithDiscount =
                          PriceConverterHelper.convertWithDiscount(
                            price,
                            discount,
                            discountType,
                          )!;
        
                      // Create cart model with current state
                      CartModel cartModelToAdd = CartModel(
                        priceWithVariation,
                        priceWithDiscount,
                        [],
                        // variations
                        (priceWithVariation - priceWithDiscount),
                        // discount amount
                        productCubit.quantity,
                        // Current quantity
                        (priceWithVariation -
                            PriceConverterHelper.convertWithDiscount(
                              priceWithVariation,
                              product.tax,
                              product.taxType,
                            )!),
                        // tax amount
                        productCubit.selectedAddon,
                        // Selected addons
                        product,
                        [], // variation
                      );
        
                      // Add to cart
                      cartCubit.addToCart(cartModelToAdd);
        
                      // Close the bottom sheet
                      Navigator.pop(context);
        
                      // Show confirmation using custom snack bar
                      showCustomSnackBarHelper(
                        '${product.name} ${'added_to_cart'.tr}',
                        isError: false
                      );
                    },
                    textStyle: rubikSemiBold.copyWith(color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
