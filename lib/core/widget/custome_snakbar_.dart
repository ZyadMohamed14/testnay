import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testnay/core/helper/my_responsive_helper.dart';

import '../../utill/dimensions.dart';
import '../../utill/styles.dart';

enum SnackBarStatus {error, success, alert, info}

void showCustomSnackBarHelper(String? message, {
  bool isError = true, bool isToast = false}) {
  /////
  final Size size = Get.size;

  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    elevation: 0,
    duration: Duration(seconds: 1),
    shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.transparent)
    ),
    content: Align(alignment: Alignment.center,
      child: Material(color: Colors.black, elevation: 0, borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [


            CircleAvatar(
              radius: 12, // Adjust radius as needed
              backgroundColor: isError ? Colors.red : Colors.green, // Background color of the circle
              child: Icon(
                isError ? Icons.close_rounded : Icons.check,
                color: Colors.white,
                size: 16, // Icon size
              ),
            ),

            const SizedBox(width: Dimensions.paddingSizeSmall),

            Flexible(child: Text(
              message ?? '',
              style: rubikBold.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeDefault,
              ),
              textAlign: TextAlign.center,
            )),

          ]),
        ),
      ),
    ),
    margin: MyResponsiveHelper.isDesktop()
        ?  EdgeInsets.only(right: size.width * 0.7, bottom: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall)
        : EdgeInsets.only(bottom: size.height * 0.08),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

  ));

}