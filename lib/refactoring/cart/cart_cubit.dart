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
      emit(CartLoaded(cartItems, newTotal));
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
      emit(CartLoaded(cartItems, newTotal));
    } catch (e) {
      emit(CartError());
    }
  }
  Future<void> UpdateCartItemQuantity(int productId,bool isIncreaseQuantity) async {
    if (state is! CartLoaded) return;

    final currentState = state as CartLoaded;
    emit(CartLoading());

    try {
      // Create new list with updated quantity
      final updatedItems = currentState.items.map((item) {
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
      emit(CartLoaded(cartItems, newTotal));
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
  }


