import '../../di_container.dart';
import 'date_converter_helper.dart';

class ProductHelper{
  static bool isProductAvailable({required Product product})=>
      product.availableTimeStarts != null && product.availableTimeEnds != null
          ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!) : false;

  // static void addToCart({required int cartIndex, required Product product}) {
  //   ResponsiveHelper.showDialogOrBottomSheet(Get.context!, CartBottomSheetWidget(
  //     product: product,
  //     fromSetMenu: true,
  //     callback: (CartModel cartModel) {
  //       showCustomSnackBarHelper(getTranslated('added_to_cart', Get.context!), isError: false);
  //     },
  //   ));
  // }
  static bool checkStock(Product product, {int? quantity}){
    int? stock;
    if(product.branchProduct?.stockType != 'unlimited' && product.branchProduct?.stock != null && product.branchProduct?.soldQuantity != null){
      stock = product.branchProduct!.stock! - product.branchProduct!.soldQuantity!;
      if(quantity != null){
        stock = stock - quantity;
      }

    }
    return stock == null || (stock > 0);
  }
  static ({List<Variation>? variatins, double? price}) getBranchProductVariationWithPrice(Product? product){

    List<Variation>? variationList;
    double? price;

    if(product?.branchProduct != null && (product?.branchProduct?.isAvailable ?? false)) {
      variationList = product?.branchProduct?.variations;
      price = product?.branchProduct?.price;

    }else{
      variationList = product?.variations;
      price = product?.price;
    }

    return (variatins: variationList, price: price);
  }


}