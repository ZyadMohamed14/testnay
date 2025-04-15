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
  double? discount = 0.0;
  String? discountType;
   List<AddOn>selectedAddon=[];
  void initPriceForCurrentProduct(Product product) {
    originalPrice = product.price!;
    discount = product.discount;
    discountType = product.discountType;
    _calculateTotalPrice();
    print('🔄 initPriceForCurrentProduct:');
    print('➡️ originalPrice: $originalPrice, quantity: $quantity, totalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity,totalPrice));
  }

  void updateProductQuantity(int newQuantity) {
    quantity = newQuantity;
    _calculateTotalPrice();
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

    _recalculateAddOnPrice();
    _calculateTotalPrice();

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
    print('🔃 Recalculatedd AddOnPrice: $addOnPrice');
  }
  void _calculateTotalPrice() {
    // Calculate base price with discount
    double basePrice = originalPrice;
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        basePrice = originalPrice - discount!;
      } else if (discountType == 'percent') {
        basePrice = originalPrice - ((discount! / 100) * originalPrice);
      }
    }
    
    // Multiply by quantity
    totalPrice = basePrice * quantity;
    
    // Add the total addon costs (this is independent of product quantity)
    totalPrice += addOnPrice;
    
    print('💰 Calculated TotalPrice: $totalPrice = (${basePrice} * ${quantity}) + ${addOnPrice}');
  }
  void removeAddOnById(int id) {
    // Store addon before removal to adjust price
    final removedAddon = selectedAddon.firstWhere(
      (addOn) => addOn.id == id,
      orElse: () => AddOn(id: id, quantity: 0, price: 0, isSelected: false),
    );

    // Remove the addon
    selectedAddon.removeWhere((addOn) => addOn.id == id);
    print('❌ Removed AddOn with ID: $id');

    // Recalculate addon price after removal
    _recalculateAddOnPrice();
    _calculateTotalPrice();

    print('✅ After removeAddOnById:');
    print('➡️ AddOnPrice: $addOnPrice, TotalPrice: $totalPrice');
    
    emit(ProductQuantityUpdated(quantity, totalPrice));
  }


  void updateProductTotalPrice(double newValue) {
    totalPrice = newValue;
    print('💰 Manually Updated TotalPrice: $totalPrice');
    emit(ProductQuantityUpdated(quantity, totalPrice));
  }


}
