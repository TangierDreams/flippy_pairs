import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/models/mod_drawer_option.dart';
import 'package:flippy_pairs/PAGES/SETTINGS/pag_settings.dart';
import 'package:flippy_pairs/UTILS/constants.dart';

class WidDrawer extends StatelessWidget {

  const WidDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    // NOMBRE DE LA APP:

    const String appName = AppGeneral.title;
    
    // LOGO DE LA APP:

    final Widget appImage = SizedBox(
      width: 90, 
      height: 90, 
      child: Image.asset(AppGeneral.logo),
    );

    // LISTA DE OPCIONES DEL MENU:

    final List<ModDrawerOption> drawerOptions = [
      ModDrawerOption(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () {
          // Navigate to the MessagesPage
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PagSettings(),
            ),
          );
        },      
      ),

    ];    

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          //CABECERA DEL MENU:

          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),

            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: 
              <Widget>[
                appImage, 

                Text(
                  appName, 
                  style: AppTexts.subtitle,
                ),

              ],
            ),
          ),

          // OPCIONES DEL MENÚ:

          ...drawerOptions.map(
            (option) => ListTile(
              leading: Icon(option.icon),
              title: Text(option.title),
              onTap: () {
                // Close the drawer before executing the action
                Navigator.pop(context);
                // Execute the custom onTap function for the option
                option.onTap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
