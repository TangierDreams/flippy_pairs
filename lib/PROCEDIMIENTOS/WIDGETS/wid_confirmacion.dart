import 'package:flutter/material.dart';

class WidConfirmacion extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final Widget? imagen;
  final bool dosBotones;
  final String textoBotonOk;
  final String textoBotonCancelar;
  final VoidCallback? onConfirmar;
  final Color? colorBotonOk;

  const WidConfirmacion({
    super.key,
    required this.titulo,
    required this.descripcion,
    this.imagen,
    this.dosBotones = true,
    this.textoBotonOk = 'Aceptar',
    this.textoBotonCancelar = 'Cancelar',
    this.onConfirmar,
    this.colorBotonOk,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagen != null) ...[imagen!, SizedBox(width: 16)],
          Expanded(child: Text(descripcion)),
        ],
      ),
      actions: _buildBotones(context),
    );
  }

  List<Widget> _buildBotones(BuildContext context) {
    if (!dosBotones) {
      return [
        TextButton(
          child: Text(textoBotonOk),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmar?.call();
          },
        ),
      ];
    }

    return [
      TextButton(child: Text(textoBotonCancelar), onPressed: () => Navigator.of(context).pop()),
      TextButton(
        child: Text(textoBotonOk, style: TextStyle(color: colorBotonOk ?? Colors.red)),
        onPressed: () {
          Navigator.of(context).pop();
          onConfirmar?.call();
        },
      ),
    ];
  }
}
