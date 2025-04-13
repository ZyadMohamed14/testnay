import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/app_constants.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/home/widget/stock_avaliable_widget.dart';

import '../../../core/dimensions.dart';
import '../../../core/helper/price_conventer_helper.dart';
import '../../../core/helper/product_helper.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../cart/cart_bottom_sheet.dart';
import '../../cart/cart_cubit.dart';
import '../home_screen.dart';
import 'add_to_cart_button.dart';

class ProductCardWidget extends StatelessWidget {
 final Product product;
 final ConfigModel configModel;

  const ProductCardWidget({super.key, required this.product,required this.configModel});

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
            decoration: BoxDecoration(
             color: Theme.of(context).cardColor,
             borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            /// for product Image and quantity button and add to fav button
            ProductImage(product: product,configModel: configModel,),

            /// for product Descrption rating and price
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
             child: Column(children: [
               const SizedBox(height: Dimensions.paddingSizeDefault),
             Row(mainAxisAlignment:MainAxisAlignment.start,
             children: [
               Flexible(child: Text(product.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikSemiBold)),
               const SizedBox(width: Dimensions.paddingSizeSmall),
               ProductTagWidget(product: product,),

             ],
             ),

             ],),
           )
          ],
        ),

        ),
      ),
    );
  }

}
class ProductImage extends StatelessWidget {
  final Product product;

  final ConfigModel configModel;
  // Determine if the current language is LTR (English) or RTL (Arabic)
  // 'ar' is for Arabic, others are typically LTR
  bool isArabicLanguage = Get.locale?.languageCode == 'ar';

  ProductImage({super.key, required this.product,required this.configModel, });

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
   product.discount!=10;
    bool isAvailable = ProductHelper.isProductAvailable(product: product);
    bool isAvailableInStock = ProductHelper.checkStock(product);
    bool isDiscountAvailable = product.discount != null && product.discount != 0;
    return Stack(
      children: [
        /// product Image
        InkWell(
          onTap: (){
            final cartItem = cartCubit.cartItems
                .firstWhereOrNull((item) => item.product?.id == product.id);

            showModalBottomSheet(
              context: context,
              builder: (context) => CartBottomSheetWidget(
                cartModel: cartItem ?? null,
                configModel: configModel,
              ),
            );

   },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(image: '${AppConstants.baseProductssImageUrl}${product.image}',
            height: 150,
            width: 220,
            fit: BoxFit.cover
            ),
          ),
        ),
        /// Wish Button
        Visibility(
          visible: isAvailable && isAvailableInStock,
          child: Positioned(
            right:!isArabicLanguage? Dimensions.paddingSizeSmall:null,
          left: isArabicLanguage?Dimensions.paddingSizeSmall:null,
            top: Dimensions.paddingSizeSmall,
            child: WishButtonWidget(product: product),
          ),
        ),
        /// discount tag
        Visibility(
          visible:isDiscountAvailable ,
          child: Positioned(
          // left:!isArabicLanguage? 1:null,
           // right: isArabicLanguage?3:null,
            child: _DiscountTagWidget(product: product,
                configModel:configModel ,),
          ),
        ),
        /// stock
        // Positioned.fill(  // This makes it fill the Stack
        //   child: Center(  // This centers the widget
        //     child: StockAvailableWidget(
        //       isAvailable: isAvailable,
        //       isAvailableInStock: isAvailableInStock,
        //     ),
        //   ),
        // ),
        /// add to cart and add quantity button
        Visibility(
          visible: isAvailable && isAvailableInStock,
          child: Positioned(
            bottom: 0, // Adds padding from bottom
            right: isArabicLanguage? Dimensions.paddingSizeSmall:null,
            left: isArabicLanguage?null:Dimensions.paddingSizeSmall,
            child: AddToCartButtonWidget(product: product,),
          ),
        ),
      ],
    );
  }
}
class WishButtonWidget extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;
  const WishButtonWidget({super.key, required this.product, this.edgeInset = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {


      return Padding(padding: edgeInset, child: Material(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: ()=> (){},
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Icon(Icons.favorite, color: Colors.white, size: Dimensions.paddingSizeDefault),
          ),
        ),
      ));

  }


}
class ProductTagWidget extends StatelessWidget {
  final Product product;
  const ProductTagWidget({
    super.key, required this.product,
  });

  @override
  Widget build(BuildContext context) {

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: product.productType == 'veg'
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColor, width: 2,
          ),
        ),
        padding: const EdgeInsets.all(1),
        child: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: product.productType == 'veg'
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      );

  }
}
class _DiscountTagWidget extends StatelessWidget {
  const _DiscountTagWidget({required this.product,required this.configModel});

  final Product product;
  final ConfigModel configModel;


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.7), borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Text(
        PriceConverterHelper.getDiscountType(discount: product.discount, discountType: product.discountType,configModel: configModel),
        style: rubikBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
      ),
    ));
  }
}
class RatingBarWidget extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBarWidget({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {

    return rating > 0 ? Row(mainAxisSize: MainAxisSize.min, children: [

      Text(rating.toStringAsFixed(1), style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

      Icon(Icons.star, color: Color(0xFFFFBA08), size: size),

    ]) : const SizedBox();
  }
}

