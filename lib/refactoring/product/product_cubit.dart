import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';

import '../../di_container.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {


  ProductCubit() : super(ProductInitial());

  int quantity=1;

  double totalPrice =0.0;
  double originalPrice = 0.0;
  double addOnPrice =0.0;
   List<AddOn>selectedAddon=[];
  void initPriceForCurrentProduct(Product product) {
    originalPrice = product.price!;
    totalPrice = originalPrice * quantity;
    print('🔄 initPriceForCurrentProduct:');
    print('➡️ originalPrice: $originalPrice, quantity: $quantity, totalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity,totalPrice));
  }

  void updateProductQuantity(int newQuantity) {
    quantity = newQuantity;
    totalPrice =originalPrice * quantity;
    print('🔄 updateProductQuantity:');
    print('➡️ New Quantity: $quantity, totalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity, totalPrice));
  }
  void addOrUpdateAddOnList(AddOn addOn) {
    final existingIndex = selectedAddon.indexWhere((element) => element.id == addOn.id);

    if (existingIndex != -1) {
      print('🔁 Updated existing AddOn: ${addOn.id}');
      selectedAddon[existingIndex] = addOn;
    } else {
      selectedAddon.add(addOn);
      print('➕ Added new AddOn: ${addOn.id}');
    }

    // Recalculate the correct total AddOn price
    _recalculateAddOnPrice();
    totalPrice = (originalPrice * quantity) + addOnPrice;

    print('✅ After addOrUpdateAddOnList:');
    print('➡️ AddOnPrice: $addOnPrice, TotalPrice: $totalPrice');

    emit(ProductQuantityUpdated(quantity, totalPrice));
  }
  void _recalculateAddOnPrice() {
    addOnPrice = 0.0;
    for (var addOn in selectedAddon) {
      if (addOn.isSelected && addOn.quantity != null && addOn.price != null) {
        addOnPrice += addOn.quantity! * addOn.price!;
      }
    }
    print('🔃 Recalculated AddOnPrice: $addOnPrice');
  }
  void removeAddOnById(int id) {
    selectedAddon.removeWhere((addOn) => addOn.id == id);
    print('❌ Removed AddOn with ID: $id');
    // Recalculate total after removal
    double oldPrice =0.0;
    for (var addOn in selectedAddon) {
      if (addOn.isSelected && addOn.quantity != null && addOn.price != null) {
        oldPrice = addOn.quantity! * addOn.price!;
      }
    }

    print('✅ After removeAddOnById:');
    print('➡️ AddOnPrice: $addOnPrice, TotalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity, totalPrice-oldPrice));
  }


  void updateProductTotalPrice(double newValue) {
    totalPrice = newValue;
    print('💰 Manually Updated TotalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity, totalPrice));
  }


}
