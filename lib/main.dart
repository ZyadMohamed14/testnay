import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testnay/core/theming/themeing.dart';
import 'package:testnay/refactoring/cart/cart_cubit.dart';
import 'package:testnay/refactoring/cart/cart_repo.dart';
import 'package:testnay/refactoring/config/config_cubit.dart';
import 'package:testnay/refactoring/config/config_repo.dart';
import 'package:testnay/refactoring/config/configration_model.dart';
import 'package:testnay/refactoring/netwrok/network_cubit.dart';

import '../core/language/tarnslation.dart';
import '../core/routing/app_router.dart';
import '../di_container.dart' as di;
import '../utill/color_resources.dart';
import 'core/dimensions.dart';
import 'core/helper/my_responsive_helper.dart';




class NayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

     home: CategoryShimmer(),
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await di.init();
 // InternetConnectivityService.instance.startListening();
  runApp(
    NayApp(),
  );
}

class CategoryShimmer extends StatelessWidget{
  bool isDesktop = MyResponsiveHelper.isDesktop();

  CategoryShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Banner Shimmer
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Name Shimmer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
          ),

          // Grid Shimmer
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? (MediaQuery.of(context).size.width - Dimensions.webScreenWidth) / 2 : 20,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : MyResponsiveHelper.isTab() ? 3 : 2,
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisExtent: 260,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child:  Container(
                    height: 300,
                    width: 300,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}