import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../app_constants.dart';
import '../../di_container.dart';

class CartRepository {
  final SharedPreferences? sharedPreferences;
  CartRepository({required this.sharedPreferences});
  String  _getCartDataKey(){
    return  '${AppConstants.cartList}_1}';
  }

  List<CartModel> getCartList() {
    List<String>? carts = [];
    if(sharedPreferences!.containsKey(_getCartDataKey())) {
      carts = sharedPreferences!.getStringList(_getCartDataKey());
    }
    List<CartModel> cartList = [];
    for (var cart in carts!) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    }

    return cartList;
  }

  Future<void> addOrUpdatedCartList(List<CartModel> cartProductList) async{
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    await sharedPreferences!.setStringList(_getCartDataKey(), carts);
  }
}

class CartModel {
  double? _price;
  double? _discountedPrice;
  List<Variation>? _variation;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  List<AddOn>? _addOnIds;
  Product? _product;
  List<List<bool?>>? _variations;


  CartModel(
      double? price,
      double? discountedPrice,
      List<Variation> variation,
      double? discountAmount,
      int? quantity,
      double? taxAmount,
      List<AddOn> addOnIds,
      Product? product,
      List<List<bool?>> variations,
      ) {
    _price = price;
    _discountedPrice = discountedPrice;
    _variation = variation;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _addOnIds = addOnIds;
    _product = product;
    _variations = variations;
  }

  double? get price => _price;
  double? get discountedPrice => _discountedPrice;
  List<Variation>? get variation => _variation;
  double? get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int? qty) => _quantity = qty;
  double? get taxAmount => _taxAmount;
  List<AddOn>? get addOnIds => _addOnIds;
  set addOnIds(List<AddOn>? value) {
    _addOnIds = value;
  }

  Product? get product => _product;
  List<List<bool?>>? get variations => _variations;


  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds!.add(AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
    if (json['variations'] != null) {
      _variations = [];
      for(int index=0; index<json['variations'].length; index++) {
        _variations!.add([]);
        for(int i=0; i<json['variations'][index].length; i++) {
          _variations![index].add(json['variations'][index][i]);
        }
      }
    }
  }

  CartModel.CopyWith(this._price, this._discountedPrice, this._variation,
      this._discountAmount, this._quantity, this._taxAmount, this._addOnIds,
      this._product, this._variations);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = _price;
    data['discounted_price'] = _discountedPrice;
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    if (_addOnIds != null) {
      data['add_on_ids'] = _addOnIds!.map((v) => v.toJson()).toList();
    }
    data['product'] = _product!.toJson();
    data['variations'] = _variations;
    return data;
  }

}

class AddOn {
  int? _id;
  int? _quantity;
  double? _price;
  bool isSelected;

  AddOn({
    int? id,
    int? quantity,
    double? price=0.0,
    this.isSelected = false,
  }) {
    _id = id;
    _quantity = quantity;
    _price = price;
  }

  int? get id => _id;
  int? get quantity => _quantity;
  double? get price => _price;

  AddOn.fromJson(Map<String, dynamic> json) : isSelected = false {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['quantity'] = _quantity;

    return data;
  }
}