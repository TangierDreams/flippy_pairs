import 'package:flippy_pairs/SHARED/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_flecha_atras.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/SERVICIOS/srv_globales.dart';

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
    // LOGO DE LA APP:

    final Widget appLogo = SizedBox(width: 50, height: 50, child: Image.asset(AppGeneral.logo));

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
          : appLogo,
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
                await reproducirSonidoGoback();

                // wait a bit
                await Future.delayed(const Duration(milliseconds: 250));

                // go back
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const WidFlechaAtras(),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}
