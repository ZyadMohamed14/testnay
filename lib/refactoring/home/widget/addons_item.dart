import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/product/product_cubit.dart';

import '../../../core/dimensions.dart';
import '../../../core/helper/price_conventer_helper.dart';
import '../../../utill/styles.dart';

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
    
    // Check if this addon is already in the cart
    final existingAddon = widget.cartModel.addOnIds?.firstWhere(
      (addon) => addon.id == widget.addOns.id && addon.isSelected,
      orElse: () => AddOn(id: -1, isSelected: false, quantity: 0),
    );
    
    if (existingAddon != null && existingAddon.id != -1) {
      isChecked = true;
      quantity = existingAddon.quantity ?? 1;
    }
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );
  }
} 