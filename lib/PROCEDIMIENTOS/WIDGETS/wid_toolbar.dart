import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_logger.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_flecha_atras.dart';
import 'package:flutter/material.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';

class WidToolbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final bool showBackButton;
  final bool showConfigButton;
  final Function()? onMenuPressed;
  final Function()? onBackButtonPressed;
  final String? subtitle;
  final VoidCallback? pFuncionCallBack;

  const WidToolbar({
    super.key,
    this.showMenuButton = true,
    this.showBackButton = false,
    this.showConfigButton = false,
    this.onMenuPressed,
    this.onBackButtonPressed,
    this.subtitle,
    this.pFuncionCallBack,
  });

  @override
  Widget build(BuildContext context) {
    // LOGO DE LA APP:

    final Widget appLogo = SizedBox(width: 50, height: 50, child: Image.asset(DatosGenerales.logoApp));

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
      backgroundColor: Colores.primero,
      foregroundColor: Colores.onPrimero,
      centerTitle: true,
      toolbarHeight: 72.0, // <-- Altura del toolbar
      title: Column(
        mainAxisSize: MainAxisSize.min, // don't stretch vertically
        children: [
          const SizedBox(height: 6),
          Text(DatosGenerales.nombreApp, style: Textos.luckiestGuy(32, Colores.segundo)),
          if (subtitle != null) ...[
            const SizedBox(height: 1), // Pequeño espacio entre título y subtítulo
            Text(subtitle!, style: Textos.chewy(14, Colores.tercero)),
          ],
        ],
      ),
      actions: <Widget>[
        // 👇 Botón de configuración
        if (showConfigButton)
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 38, // 👈 Tamaño del icono
            color: Colores.tercero, // 👈 Color del icono
            tooltip: 'Configuración',
            onPressed: () async {
              SrvLogger.grabarLog('wid_toolbar', 'AppBar()', 'Botón de configuración pulsado');
              await SrvSonidos.boton();
              if (context.mounted) {
                Navigator.pushNamed(context, '/config');
              }
            },
          ),

        // 👇 Botón de volver atrás
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                SrvLogger.grabarLog('wid_toolbar', 'AppBar()', 'Volvemos atras desde la toolbar');
                await SrvSonidos.boton();
                if (context.mounted) {
                  if (pFuncionCallBack != null) {
                    pFuncionCallBack!();
                  }
                  Navigator.pop(context);
                } else {
                  SrvLogger.grabarLog('wid_toolbar', 'AppBar()', 'No hemos encontrado el contexto');
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
