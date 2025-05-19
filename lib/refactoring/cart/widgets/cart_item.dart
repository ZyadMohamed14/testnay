import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';
import 'package:testnay/refactoring/config/config_cubit.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/home/widget/quantity_button.dart';

import '../../../app_constants.dart';
import '../../../core/dimensions.dart';
import '../../../core/helper/price_conventer_helper.dart';
import '../../../di_container.dart';
import '../../../utill/styles.dart';
import '../../home/home_screen.dart';
import '../../home/widget/product_card.dart';

class CartListWidget extends StatefulWidget {

  @override
  State<CartListWidget> createState() => _CartListWidgetState();
}

class _CartListWidgetState extends State<CartListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<CartCubit>().getCartData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:state.items.length,
            itemBuilder: (context, index) {
              final cartModel = state.items[index];
              return CartItem(cartModel: cartModel,);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class CartItem extends StatelessWidget {
  CartModel cartModel;
   CartItem({
    super.key,
    required this.cartModel,
  });
  @override
  Widget build(BuildContext context) {
    final configModel = context.read<ConfigCubit>().configModel;
    return DecoratedBox(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomImageWidget(
              image:
              '${AppConstants.baseProductssImageUrl}${cartModel.product!.image}',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

          ),
          Column(
            children: [
              Text(
                cartModel.product!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: rubikSemiBold,
              ),
              RatingBarWidget(
                rating: cartModel.product!.rating!.isNotEmpty
                    ? cartModel.product!.rating![0].average! : 0.0,
                size: 15,
              ),
              if (cartModel.product!.discount != null && cartModel.product!.discount! > 0)
                Text(
                  PriceConverterHelper.convertPrice(
                    cartModel.product!.price,
                    configModel!,
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
                  cartModel.product!.discount != null && cartModel.product!.discount ! > 0
                      ? PriceConverterHelper.convertWithDiscount(
                    cartModel.product!.price,
                    cartModel.product!.discount,
                    cartModel.product!.discountType,
                  ) :cartModel.product!.price,
                  configModel!,
                ),
                style: rubikBold.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          QuantityButton()
        ],
      ),
    );
  }
}
