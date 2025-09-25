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
          GestureDetector(
            onTapDown: (_) {
              // 👇 play sound immediately when finger touches
              SrvSounds().emitGobackSound();
            },
            onTap: () {
              // 👇 navigate when finger is released
              if (onBackButtonPressed != null) {
                onBackButtonPressed!(); // call the custom callback if provided
              } else if (context.mounted) {
                Navigator.of(context).pop(); // default behavior
              }
            },
            child: Padding(padding: const EdgeInsets.all(6), child: WidArrowBack()),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}
