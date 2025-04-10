import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';



class MyResponsiveHelper {

  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    final size = Get.size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isPhone() {
    // Define a threshold for phones
    final double shortestSide = Get.size.shortestSide;
    return shortestSide < 600;  // Phones generally have a shortest side < 600px
  }

  static bool isTab() {
    final size = Get.size.width;
    if (size < 1100 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop() {
    final size = Get.size.width;
    if (size >= 1100) {
      return true;
    } else {
      return false;
    }
  }

  static void showDialogOrBottomSheet(BuildContext context, Widget view, {bool isDismissible = true}) {
    if (MyResponsiveHelper.isDesktop()) {
      showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: view,
        ),
      );
    } else {
      showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) => view,
      );
    }
  }
}