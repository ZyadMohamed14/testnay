import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:testnay/utill/color_resources.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 1'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'test'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 100,
              color: Theme.of(context).canvasColor,
              margin: const EdgeInsets.all(10),
            ),
            Container(
              width: 200,
              height: 100,
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.all(10),
            ),
            Container(
              width: 200,
              height: 100,
              color: Theme.of(context).secondaryHeaderColor,
              margin: const EdgeInsets.all(10),
            ),
            Container(
              width: 200,
              height: 100,
              color: Theme.of(context).colorScheme.secondary,
              margin: const EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Center(
        child: BlocBuilder<ThemeCubit, AppTheme>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              icon: Icon(
                state == AppTheme.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }
}
class LanguageTestScreen extends StatelessWidget {
  const LanguageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentDirection = Get.locale?.languageCode == 'ar'
        ? 'Right to Left (RTL)'
        : 'Left to Right (LTR)';

    print("Current Text Direction: $currentDirection");
    return Scaffold(
      appBar: AppBar(title: Text('Test Language')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('home'.tr,),
            ElevatedButton(onPressed: (){}, child:Row(
              children: [
                Icon(Icons.insert_emoticon_sharp,color: Colors.red,),
                Text('home'.tr,)
              ],
            )),
            SizedBox(height: 10),
            Text('cart'.tr, ),
            SizedBox(height: 10),
            Text('menu'.tr,),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle language between Arabic and English
                final currentLocale = Get.locale?.languageCode;
                if (currentLocale == 'en') {
                  Get.updateLocale(Locale('ar')); // Switch to Arabic
                } else {
                  Get.updateLocale(Locale('en')); // Switch to English
                }
              },
              child: Text('Switch Language'),
            ),
          ],
        ),
      ),
    );
  }
}
