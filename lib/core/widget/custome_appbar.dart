import 'package:flutter/material.dart';

import '../../utill/dimensions.dart';
import '../../utill/styles.dart';
import '../helper/my_responsive_helper.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final BuildContext? context;
  final Widget? actionView;
  final bool centerTitle;
  final bool isTransparent;
  final double elevation;
  final Widget? leading;
  final Color? titleColor;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.context,
    this.actionView,
    this.centerTitle = true,
    this.isTransparent = false,
    this.elevation = 0,
    this.leading,
    this.titleColor
  });

  @override
  Widget build(BuildContext context) {
    return MyResponsiveHelper.isDesktop() ? const SizedBox() : AppBar(
      title: Text(
        title!,
        style: rubikSemiBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: titleColor ?? (isTransparent ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
      centerTitle: centerTitle,
      leading: isBackButtonExist ? IconButton(
        icon: leading ?? const Icon(Icons.arrow_back_ios),
        color: titleColor ?? (isTransparent ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      actions: actionView != null ? [Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: actionView!,
      )] : [],
      backgroundColor: isTransparent ? Colors.transparent : Theme.of(context).cardColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, MyResponsiveHelper.isDesktop() ? 100 : 50);
}