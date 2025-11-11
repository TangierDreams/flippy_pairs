import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_confirmacion.dart';
import 'package:flutter/material.dart';

class SrvConfirmacion {
  static Future<bool?> confirmacionSimple({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    Widget? imagen,
    bool dosBotones = true,
    String textoBotonOk = 'Aceptar',
    String textoBotonCancelar = 'Cancelar',
    Color? colorBotonOk,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => WidConfirmacion(
        titulo: titulo,
        descripcion: descripcion,
        imagen: imagen,
        dosBotones: dosBotones,
        textoBotonOk: textoBotonOk,
        textoBotonCancelar: textoBotonCancelar,
        colorBotonOk: colorBotonOk,
      ),
    );
  }

  static Future<void> confirmacionConAccion({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    Widget? imagen,
    bool dosBotones = true,
    String textoBotonOk = 'Aceptar',
    String textoBotonCancelar = 'Cancelar',
    Color? colorBotonOk,
    required VoidCallback onConfirmar,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => WidConfirmacion(
        titulo: titulo,
        descripcion: descripcion,
        imagen: imagen,
        dosBotones: dosBotones,
        textoBotonOk: textoBotonOk,
        textoBotonCancelar: textoBotonCancelar,
        colorBotonOk: colorBotonOk,
        onConfirmar: onConfirmar,
      ),
    );
  }
}
