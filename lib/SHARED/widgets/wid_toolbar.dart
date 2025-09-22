import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flippy_pairs/SHARED/UTILS/constants.dart';

class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final bool showBackButton;
  final bool showCloseButton;
  final Function()? onMenuPressed;
  final Function()? onBackButtonPressed;
  final Function()? onCloseButtonPressed;
  final String? subtitle;
  final List<Widget>? extraActions;
  final double toolbarHeight;

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
    this.toolbarHeight = 72.0, // increase if fonts are larger
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
                  onPressed:
                      onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
                );
              },
            )
          : null,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.contrast,
      centerTitle: true,
      toolbarHeight: toolbarHeight, // <-- ensures the bar is tall enough
      title: Column(
        mainAxisSize: MainAxisSize.min, // don't stretch vertically
        children: [
          const SizedBox(height: 6), // small top offset *inside* the bar
          Text(
            AppGeneral.title,
            style: GoogleFonts.luckiestGuy(
              textStyle: const TextStyle(
                fontSize: 32,
                height: 0.9,
                color: Colors.orange,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black87,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 1), // small gap between title and subtitle
            Text(
              subtitle!,
              style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                  fontSize: 14,
                  height: 0.7,
                  color: Colors.yellow,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
