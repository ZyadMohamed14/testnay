import 'package:get/get.dart';
import 'package:testnay/refactoring/config/configration_model.dart';

class PriceConverterHelper {
  static String convertPrice(double? price,ConfigModel configModel, {double? discount, String? discountType,}) {

    if(discount != null && discountType != null){
      if(discountType == 'amount') {
        price = price! - discount;
      }else if(discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }
    return configModel.currencySymbolPosition == 'left'
        ? '${configModel.currencySymbol}' '${price?.toStringAsFixed(configModel.decimalPointSettings!).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}'
        : '${price!.toStringAsFixed(configModel.decimalPointSettings!).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}' ' ${configModel.currencySymbol}';
  }

  static double? convertWithDiscount(double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price = price! - discount!;
    }else if(discountType == 'percent' && (discount ?? 0) > 0) {
      price = price! - ((discount! / 100) * price);
    }
    return price;
  }

  static double addonTaxCalculation(double? addOnTax, double totalTax, double? itemPrice,  String? discountType){
    if(discountType == 'percent' && addOnTax != null && itemPrice != null){
      totalTax = totalTax + ((addOnTax/ 100) * itemPrice);
    }else if (discountType == 'amount'){
      totalTax = totalTax + (addOnTax ?? 0);
    }
    return totalTax;
  }



  static double? convertDiscount(ConfigModel configModel, double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price =  discount;
    }else if(discountType == 'percent') {
      price = (discount! / 100) * price!;
    }
    return price;
  }

  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String getDiscountType({required double? discount, required String? discountType,required ConfigModel configModel}) {
    return '${discountType == 'percent' ? '${discount?.toInt()} %' : PriceConverterHelper.convertPrice(discount,configModel)} ${'off'.tr}';
  }
}