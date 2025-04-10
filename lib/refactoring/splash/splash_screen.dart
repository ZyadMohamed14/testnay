// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testnay/core/helper/my_responsive_helper.dart';
import 'package:testnay/refactoring/netwrok/network_cubit.dart';

import '../../core/routing/app_router.dart';
import '../../utill/images.dart';
import '../config/config_cubit.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start the navigation check when the widget is built

    Future.delayed(const Duration(seconds: 3), () {
      bool isConnected = InternetConnectivityService.instance.isOffline.value;
      // You can handle the navigation based on the connectivity status
      if (!isConnected) {
        Navigator.pushReplacementNamed(context, Routes.homeScreen);
      } else {
        Navigator.pop(context);
      }
    });

    bool isDesktop = MyResponsiveHelper.isDesktop();
    return Stack(
      children: [
        // Make the image fill the entire screen
        Positioned.fill(
          child: CustomAssetImageWidget(
            Images.splashBackground,
            fit: BoxFit.cover,
          ),
        ),
        // Add the color overlay on top of the image
        Positioned.fill(
          child: Container(
            color: Color(0xFF72b89f).withOpacity(0.9), // Color with opacity
          ),
        ),
        // Center the logo in the middle of the screen
        Center(
          child: Image.asset(
            color: Colors.white,
            Images.webAppBarLogo, // Path to your logo image
            width: 150, // Adjust the width as needed
            height: 150, // Adjust the height as needed
          ),
        ),
      ],
    );
  }
}
class CustomAssetImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BlendMode? colorBlendMode;
  final Color? color;
  const CustomAssetImageWidget(this.image,
      {super.key,
        this.height,
        this.width,
        this.fit = BoxFit.cover,
        this.color,
        this.colorBlendMode});

  @override
  Widget build(BuildContext context) {
    final isSvg = image.contains('.svg', image.length - '.svg'.length);

    return isSvg
        ? SvgPicture.asset(
      image,
      width: height,
      height: width,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: fit,
    )
        : Image.asset(image,
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode);
  }
}

/*
listener: (context, state) {
        if (state is ConfigLoaded) {
          print('Loaded');
          // Navigate to home after config is loaded
        //  if(isDesktob) Navigator.pushReplacementNamed(context, Routes.homeScreen);
        //  else Navigator.pushReplacementNamed(context, 'test');
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is ConfigError) {
          print('errorrrrrrrrrrrrrrr');
          // Show error and retry option
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load config: ${state.message}'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => context.read<ConfigCubit>().loadConfig(),
              ),
            ),
          );
        }
      },
 */