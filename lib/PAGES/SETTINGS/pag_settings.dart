import 'package:flutter/material.dart';
import 'package:flippy_pairs/SHARED/WIDGETS/wid_toolbar.dart';

class PagSettings extends StatelessWidget {
  const PagSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //Toolbar:
      
      appBar: WidToolbar(
        showMenuButton: false,
        showBackButton: true,
      ),

      body: Center(
        child: Text("Página de Settings")
      ),

    );
  }
}

