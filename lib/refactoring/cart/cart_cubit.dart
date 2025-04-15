import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:testnay/di_container.dart';
import 'package:testnay/refactoring/config/config_repo.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

import 'cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepo;
    List<CartModel>cartItems=[];
    double totalPrice =0.0;
    double priceForCurrentProduct=0.0;
    late ConfigModel configModel;
  CartCubit({required this.cartRepo}) : super(CartInitial()) {
    cartItems = cartRepo.getCartList();
  }


  Future<void> getCartData() async {
    emit(CartLoading());
    try {
       cartItems = cartRepo.getCartList();
      final total = _calculateTotal(cartItems);
      emit(CartLoaded(cartItems, total));
    } catch (e) {
      emit(CartError());
    }
  }

  void updatePriceForCurrentProduct(Product product) {
    final cartItem = getCartModel(product.id!);
    if (cartItem != null) {
      // Recalculate the price based on quantity and any discounts
      priceForCurrentProduct = (cartItem.discountedPrice ?? cartItem.product!.price!) * cartItem.quantity!;
    } else {
      // If the product is not in the cart, initialize its price
      priceForCurrentProduct = product.price!;
    }
    emit(CartLoaded(cartItems, _calculateTotal(cartItems)));
  }
  Future<void> addToCart(CartModel newItemOrExistingItem) async {

    emit(CartLoading());

    try {
     // final updatedItems = List<CartModel>.from(currentState.items);
      bool itemExists = false;

      // Find and update existing item
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].product!.id == newItemOrExistingItem.product!.id) {
          cartItems[i].quantity =  cartItems[i].quantity! + newItemOrExistingItem.quantity!;
          itemExists = true;
          break;
        }
      }

      // Add new item if not exists
      if (!itemExists) {
        cartItems.add(newItemOrExistingItem);
      }

      await cartRepo.addOrUpdatedCartList(cartItems);
      final newTotal = _calculateTotal(cartItems);
      emit(CartUpdated(cartItems, newTotal, CartAction.add));
    } catch (e) {
      emit(CartError());
    }
  }
  bool isProductInCart(int productId) {
    return cartItems.any((item) => item.product?.id == productId);
  }
  CartModel? getCartModel(int productId) {
    return cartItems.firstWhereOrNull((item) => item.product?.id == productId);
  }
  double _calculateTotal(List<CartModel> items) {
    double total = 0;
    for (var item in items) {
      total += (item.discountedPrice ?? 0) * (item.quantity ?? 1);
    }
    return total;
  }

  Future<void> removeFromCart(CartModel itemToRemove, int cartIndex) async {

    emit(CartLoading());

    try {
     // final updatedItems = List<CartModel>.from(currentState.items);
      cartItems.removeAt(cartIndex);
      await cartRepo.addOrUpdatedCartList(cartItems);
      final newTotal = _calculateTotal(cartItems);
      emit(CartUpdated(cartItems, newTotal, CartAction.remove));
    } catch (e) {
      emit(CartError());
    }
  }
  Future<void> UpdateCartItemQuantity(int productId,bool isIncreaseQuantity) async {
    if (state is! CartLoaded && state is! CartUpdated) return;

    emit(CartLoading());

    try {
      // Create new list with updated quantity
      final updatedItems = cartItems.map((item) {
        if (item.product!.id == productId) {
          if(item.quantity! !=0){
            if(isIncreaseQuantity){
              item.quantity = item.quantity! + 1;
            }else{
              item.quantity = item.quantity! -1;
            }
          }
        }
        return item;
      }).toList();

      // Save to repository
      await cartRepo.addOrUpdatedCartList(cartItems);

      // Calculate new total
      final newTotal = _calculateTotal(cartItems);

      // Emit updated state
      emit(CartUpdated(cartItems, newTotal, isIncreaseQuantity ? CartAction.increase : CartAction.decrease));
    } catch (e) {
      emit(CartError());
    }
  }
  int getProductQuantity(int productId) {

    int quantity=0;
   // final currentState = state as CartLoaded;
    cartItems.forEach((cartItem){
      if(cartItem.product!.id==productId)quantity = cartItem.quantity!;
    });
   
    return quantity;
  }
  bool isAddOnSelected(int productId, int addOnId) {
    return cartItems
        .firstWhere(
          (item) => item.product?.id == productId,

    )
        .addOnIds
        ?.any((addOn) => addOn.id == addOnId && addOn.isSelected)
        ?? false;
  }
  void updateTotalPrice (double newValue){
    totalPrice = totalPrice + newValue;
  }
  Future<void> initializeCart() async {
    emit(CartLoading());
    try {
      final items = cartRepo.getCartList();
      final total = _calculateTotal(items);
      emit(CartLoaded(items, total));
    } catch (e) {
      emit(CartError());
    }
  }
  Future<void> clearCart() async {
    emit(CartLoading());
    try {
      cartItems.clear();
      await cartRepo.addOrUpdatedCartList([]);
      emit(CartUpdated([], 0.0, CartAction.remove));
    } catch (e) {
      emit(CartError());
    }
  }
  List<CartModel> get items {
    if (state is CartLoaded) {
      return (state as CartLoaded).items;
    } else if (state is CartUpdated) {
      return (state as CartUpdated).items;
    } else {
      return [];
    }
  }

  double get cartTotal {
    if (state is CartLoaded) {
      return (state as CartLoaded).total;
    } else if (state is CartUpdated) {
      return (state as CartUpdated).total;
    } else {
      return 0.0;
    }
  }

  Future<void> setExactQuantity(int productId, int newQuantity) async {
    emit(CartLoading());
    
    try {
      // Find the item index and model
      int itemIndex = -1;
      CartModel? existingModel;
      
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].product!.id == productId) {
          itemIndex = i;
          existingModel = cartItems[i];
          break;
        }
      }
      
      if (itemIndex >= 0 && existingModel != null) {
        // Remove the existing item
        cartItems.removeAt(itemIndex);
        
        // Create a new cart model with the exact quantity we want
        CartModel newModel = CartModel(
          existingModel.price!,
          existingModel.discountedPrice!,
          existingModel.variation ?? [],
          existingModel.discountAmount!,
          newQuantity, // Set exact quantity
          existingModel.taxAmount!,
          existingModel.addOnIds ?? [],
          existingModel.product!,
          existingModel.variations ?? [],
        );
        
        // Add the new model to the list
        cartItems.add(newModel);
        
        // Update storage
        await cartRepo.addOrUpdatedCartList(cartItems);
        
        // Calculate the new total and emit the updated state
        final newTotal = _calculateTotal(cartItems);
        
        // Determine the appropriate action
        CartAction action = (existingModel.quantity ?? 0) < newQuantity 
            ? CartAction.increase 
            : CartAction.decrease;
            
        emit(CartUpdated(cartItems, newTotal, action));
      }
    } catch (e) {
      emit(CartError());
    }
  }
}


