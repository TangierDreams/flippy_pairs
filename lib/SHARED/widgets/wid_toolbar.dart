import 'package:flutter/material.dart';
import 'package:flippy_pairs/UTILS/constants.dart';

class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final bool showBackButton;
  final bool showCloseButton;
  final Function()? onMenuPressed;
  final Function()? onBackButtonPressed;
  final Function()? onCloseButtonPressed;

  const WidToolbar({
    super.key,
    this.showMenuButton = true,
    this.showBackButton = false,
    this.showCloseButton = false,
    this.onMenuPressed,
    this.onBackButtonPressed,
    this.onCloseButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: showMenuButton
      //     ? IconButton(icon: const Icon(Icons.menu), onPressed: onMenuPressed)
      //     : null,
        leading: showMenuButton
            ? Builder(
                // Use a Builder to get the Scaffold's context
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(), // Open the drawer
                  );
                },
              )
            : null,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.contrast,    
      title: Text(AppGeneral.title),
      centerTitle: false,
      actions: <Widget>[
        if (showBackButton)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
          )
        else if (showCloseButton)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed:
                onCloseButtonPressed ?? () => Navigator.of(context).pop(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
