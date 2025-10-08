import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';

class PagConfiguracion extends StatefulWidget {
  const PagConfiguracion({super.key});

  @override
  State<PagConfiguracion> createState() => _PagConfiguracionState();
}

class _PagConfiguracionState extends State<PagConfiguracion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),

      body: Container(alignment: AlignmentGeometry.center, child: Text("Tonto el que lo lea...")),
    );
  }
}
