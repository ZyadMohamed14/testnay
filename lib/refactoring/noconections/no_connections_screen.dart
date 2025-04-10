import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/dimensions.dart';
import '../../core/helper/my_responsive_helper.dart';
import '../../core/routing/app_router.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';
import '../netwrok/network_cubit.dart';
import '../splash/splash_screen.dart';


class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onConnectionRestored;

  const NoInternetScreen({
    super.key,
    this.onConnectionRestored,
  });

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();


    // Setup listener for connectivity changes
    InternetConnectivityService.instance.isOffline.addListener(_connectivityListener);
  }

  void _connectivityListener() {
    if (!InternetConnectivityService.instance.isOffline.value) {
        Navigator.pop(context);
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    }
  }

  @override
  void dispose() {
    // Remove listener and clean up
    InternetConnectivityService.instance.isOffline.removeListener(_connectivityListener);
    InternetConnectivityService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Internet Connection \n Please Check your Internet Connection', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}