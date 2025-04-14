import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/product/product_cubit.dart';

import '../../app_constants.dart';
import '../../core/dimensions.dart';
import '../../core/helper/date_converter_helper.dart';
import '../../core/helper/price_conventer_helper.dart';
import '../../core/helper/product_helper.dart';
import '../../core/widget/custome_button_widget.dart';
import '../../di_container.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';
import '../home/home_screen.dart';
import '../home/widget/product_card.dart';
import '../splash/splash_screen.dart';
import 'cart_repo.dart';

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
    print('zyad ${product.name}');

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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
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
                          bottom: -20,
                          // Adjust this value to control how much extends beyond the image
                          left: 0,
                          right: 0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.5),
                                  blurRadius: Dimensions.radiusDefault,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              // height: 120,
                              child: Material(
                                elevation: 4.0,
                                // Add elevation to create a shadow effect
                                borderRadius: BorderRadius.circular(16),
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
                                  subtitle: RatingBarWidget(
                                    rating:
                                        product.rating!.isNotEmpty
                                            ? product.rating![0].average!
                                            : 0.0,
                                    size: 15,
                                  ),
                                  trailing: Text(
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
                          ),
                        ),

                        /// fav button
                        Positioned(
                          right: !isArabicLanguage ? Dimensions.paddingSizeSmall : null,
                          left: isArabicLanguage ? Dimensions.paddingSizeSmall : null,
                          child: WishButtonWidget(product: product),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// Product Description
                    ProductDescription(product: product, configModel: configModel),
                    const SizedBox(height: 30),

                    /// for Addons
                    if (product.addOns!.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.5),
                              blurRadius: Dimensions.radiusDefault,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: product.addOns!.length,
                          itemBuilder: (context, index) {
                            final addOn = product.addOns![index];
                            return AddonsItem(addOns: addOn, cartModel: cartModel!, configModel: configModel,);
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],


                  ],
                ),
              ),
            ),

          ),
          /// for bottom Total amount, quantity, & add to cart button section

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

                  // Determine the current total price from the state
                  if (state is ProductQuantityUpdated) {
                    currentTotalPrice = state.totalPrice;
                  }
                   print('sjisdsdsdsodsoddjdo${currentTotalPrice}');
                  return Text(
                    PriceConverterHelper.convertPrice(
                      currentTotalPrice,
                      configModel,
                    ),
                    style: rubikSemiBold.copyWith(
                      color: Theme.of(context).primaryColor,
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
              Expanded(child: CustomButtonWidget(
                btnTxt: 'Add To Cart',
                onTap: (){},
                textStyle: rubikSemiBold.copyWith(color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
              ))
            ],
          )
        ],
      ),
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
                      ? _VegTagView(product: product, configModel: configModel)
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
  final ConfigModel configModel;
  final CartModel cartModel;

  const AddonsItem({
    super.key,
    required this.addOns,
    required this.cartModel,
    required this.configModel,
  });

  @override
  State<AddonsItem> createState() => _AddonsItemState();
}

class _AddonsItemState extends State<AddonsItem> {
  bool isChecked = false;
  int quantity = 0;
  late ProductCubit productCubit;

  @override
  void initState() {
    super.initState();
    productCubit = context.read<ProductCubit>();
  }

  void _toggleSelection(bool? newValue) {
    if (newValue == null) return;

    setState(() {
      isChecked = newValue;
      quantity = newValue ? 1 : 0;
    });

    if (isChecked) {
      productCubit.addOrUpdateAddOnList(AddOn(
        id: widget.addOns.id,
        quantity: quantity,
        price: widget.addOns.price,
        isSelected: true,
      ));
    } else {
      productCubit.removeAddOnById(widget.addOns.id!);
    }
  }

  void _increaseQuantity() {
    setState(() => quantity++);
    productCubit.addOrUpdateAddOnList(AddOn(
      id: widget.addOns.id,
      quantity: quantity,
      price: widget.addOns.price,
      isSelected: true,
    ));
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() => quantity--);
      productCubit.addOrUpdateAddOnList(AddOn(
        id: widget.addOns.id,
        quantity: quantity,
        price: widget.addOns.price,
        isSelected: true,
      ));
    } else {
      _toggleSelection(false); // This will also remove from cubit
    }
  }

  void _removeAddOn() {
    _toggleSelection(false);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('addons'.tr, style: rubikSemiBold),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    onChanged:(bool? newValue){
                      _toggleSelection(newValue);

                    },
                    visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                  ),
                  Expanded(
                    child: Text(
                      widget.addOns.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),

                  Visibility(
                    visible: !isChecked,
                    child: Text(
                      PriceConverterHelper.convertPrice(widget.addOns.price!, widget.configModel),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),

                  Visibility(
                    visible: isChecked,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: quantity > 1 ? _decreaseQuantity : _removeAddOn,
                          icon: Icon(
                            quantity > 1 ? Icons.remove_circle_outline : Icons.delete_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text('$quantity', style: robotoRegular.copyWith(fontSize: 16)),
                        IconButton(
                          onPressed: _increaseQuantity,
                          icon: Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class QuantityButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        int currentQuantity = 0;

        // Determine the current quantity from the state
        if (state is ProductQuantityUpdated) {
          currentQuantity = state.quantity ;
        }

        return Row(
          children: [
            // Decrement Button
            InkWell(
              onTap: () {
                if (currentQuantity > 1) {
                  context.read<ProductCubit>().updateProductQuantity(currentQuantity - 1);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: const Icon(Icons.remove, size: Dimensions.fontSizeExtraLarge),
              ),
            ),

            // Display Current Quantity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(
                currentQuantity.toString(),
                style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              ),
            ),

            // Increment Button
            InkWell(
              onTap: () {
                context.read<ProductCubit>().updateProductQuantity(currentQuantity + 1);
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: const Icon(Icons.add, size: Dimensions.fontSizeExtraLarge, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
