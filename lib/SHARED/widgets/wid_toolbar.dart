// import 'package:flutter/material.dart';
// import 'package:flippy_pairs/UTILS/constants.dart';

// class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
//   final bool showMenuButton;
//   final bool showBackButton;
//   final bool showCloseButton;
//   final Function()? onMenuPressed;
//   final Function()? onBackButtonPressed;
//   final Function()? onCloseButtonPressed;
//   final List<Widget>? extraActions;

//   const WidToolbar({
//     super.key,
//     this.showMenuButton = true,
//     this.showBackButton = false,
//     this.showCloseButton = false,
//     this.onMenuPressed,
//     this.onBackButtonPressed,
//     this.onCloseButtonPressed,
//     this.extraActions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//         leading: showMenuButton
//             ? Builder(
//                 // Use a Builder to get the Scaffold's context
//                 builder: (BuildContext context) {
//                   return IconButton(
//                     icon: const Icon(Icons.menu),
//                     onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(), // Open the drawer
//                   );
//                 },
//               )
//             : null,
//       backgroundColor: AppColors.primary,
//       foregroundColor: AppColors.contrast,    
//       title: Text(AppGeneral.title),
//       centerTitle: false,
//       actions: <Widget>[
//         if (showBackButton) 
//           IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
//           )
//         else if (showCloseButton)
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed:
//                 onCloseButtonPressed ?? () => Navigator.of(context).pop(),
//           ),
//         if (extraActions != null) ...extraActions!,          
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }


import 'package:flutter/material.dart';
import 'package:flippy_pairs/UTILS/constants.dart';

class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final bool showBackButton;
  final bool showCloseButton;
  final Function()? onMenuPressed;
  final Function()? onBackButtonPressed;
  final Function()? onCloseButtonPressed;
  final String? subtitle; 
  final List<Widget>? extraActions;

  const WidToolbar({
    super.key,
    this.showMenuButton = true,
    this.showBackButton = false,
    this.showCloseButton = false,
    this.onMenuPressed,
    this.onBackButtonPressed,
    this.onCloseButtonPressed,
    this.subtitle,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
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
      centerTitle: true,    
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(AppGeneral.title),
          if (subtitle != null) 
            Text(
              subtitle!,
              style: AppTexts.smallSubtitle,
            ),
        ],
      ),
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
        if (extraActions != null) ...extraActions!,  
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

