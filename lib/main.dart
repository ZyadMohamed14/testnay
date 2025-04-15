import 'dart:ui';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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




class NayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit()..toggleTheme(),
        ),
        BlocProvider(
          create: (_) => ConfigCubit(di.sl.get<ConfigRepository>())..loadConfig(),
        ),
        BlocProvider(
          create: (_) => CartCubit(cartRepo: di.sl.get<CartRepository>()),
        ),

      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, themeState) {

          return GetMaterialApp(
            scrollBehavior: MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            ),
            theme: themeState == AppTheme.light ? dark : light,
            translations: AppTranslations(),
            textDirection: Get.locale?.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            debugShowCheckedModeBanner: false,
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en'),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute:Routes.splashScreen,
          );
        },
      ),
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  InternetConnectivityService.instance.startListening();
  runApp(
    NayApp(),
  );
}