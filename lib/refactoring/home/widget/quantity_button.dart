import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnay/refactoring/product/product_cubit.dart';

import '../../../core/dimensions.dart';
import '../../../utill/styles.dart';

class QuantityButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        int currentQuantity = 0;

        // Determine the current quantity from the state
        if (state is ProductQuantityUpdated) {
          currentQuantity = state.quantity;
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