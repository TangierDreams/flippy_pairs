import 'package:flippy_pairs/SHARED/SERVICES/srv_sounds.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_arrow_back.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/UTILS/constants.dart';

class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final bool showBackButton;
  final Function()? onMenuPressed;
  final Function()? onBackButtonPressed;
  final String? subtitle;

  const WidToolbar({
    super.key,
    this.showMenuButton = true,
    this.showBackButton = false,
    this.onMenuPressed,
    this.onBackButtonPressed,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showMenuButton
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
                );
              },
            )
          : null,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.contrast,
      centerTitle: true,
      toolbarHeight: 72.0, // <-- Altura del toolbar
      title: Column(
        mainAxisSize: MainAxisSize.min, // don't stretch vertically
        children: [
          const SizedBox(height: 6),
          Text(AppGeneral.title, style: AppTexts.textStyleOrange32),
          if (subtitle != null) ...[
            const SizedBox(height: 1), // Pequeño espacio entre título y subtítulo
            Text(subtitle!, style: AppTexts.textStyleYellow14),
          ],
        ],
      ),
      actions: <Widget>[
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                // play sound
                await SrvSounds().emitGobackSound();

                // wait a bit
                await Future.delayed(const Duration(milliseconds: 250));

                // go back
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const WidArrowBack(),
            ),
          ),

        //       IconButton(
        //         icon: const Icon(Icons.arrow_back),
        //         onPressed: () async {
        //           // play your goback sound
        //           await SrvSounds().emitGobackSound();

        //           // wait a little before navigating
        //           await Future.delayed(const Duration(milliseconds: 250));

        //           // navigate back
        //           if (context.mounted) {
        //             Navigator.pop(context);
        //           }
        //         },
        //       ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}
