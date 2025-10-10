import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_sonidos.dart';
import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para TextInputFormatter

class PagConfiguracion extends StatefulWidget {
  const PagConfiguracion({super.key});

  @override
  State<PagConfiguracion> createState() => _PagConfiguracionState();
}

class _PagConfiguracionState extends State<PagConfiguracion> {
  final TextEditingController _nombreUsuario = TextEditingController();
  bool _sonidoActivado = true;
  bool _musicaActivada = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Toolbar:
      appBar: WidToolbar(showMenuButton: false, showBackButton: true, subtitle: "Harden Your Mind Once and for All!"),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //------------------------------------------------------------------
            // Pedimos el alias del usuario
            //------------------------------------------------------------------
            TextField(
              controller: _nombreUsuario,
              inputFormatters: [LengthLimitingTextInputFormatter(25)],
              decoration: InputDecoration(
                labelText: 'Alias',
                hintText: 'Introduce un nombre que te guste...',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            //------------------------------------------------------------------
            // Activar o desactivar sonidos
            //------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Activar o desactivar sonidos...', style: TextStyle(fontSize: 16)),
                Switch(
                  // 1. Valor actual del estado
                  value: _sonidoActivado,
                  // 2. Función que se llama cuando el usuario toca el switch
                  onChanged: (bool newValue) {
                    // Actualiza el estado y redibuja la interfaz
                    setState(() {
                      _sonidoActivado = newValue;
                    });
                    // Aquí añadirías la lógica para guardar la preferencia (p. ej. en SharedPreferences)
                    debugPrint('Sonidos: ${_sonidoActivado ? 'Activado' : 'Desactivado'}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            //------------------------------------------------------------------
            // Activar o desactivar música
            //------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Activar o desactivar música...', style: TextStyle(fontSize: 16)),
                Switch(
                  // 1. Valor actual del estado
                  value: _musicaActivada,
                  // 2. Función que se llama cuando el usuario toca el switch
                  onChanged: (bool newValue) {
                    // Actualiza el estado y redibuja la interfaz
                    setState(() {
                      _musicaActivada = newValue;
                    });
                    // Aquí añadirías la lógica para guardar la preferencia (p. ej. en SharedPreferences)
                    debugPrint('Música: ${_sonidoActivado ? 'Activada' : 'Desactivada'}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            //------------------------------------------------------------------
            // Botón de confirmación de datos
            //------------------------------------------------------------------
            ElevatedButton(
              onPressed: () async {
                _guardarDatos(context);
              },
              child: const Text('Guardar datos'),
            ),
          ],
        ),
      ),
    );
  }

  void _cargarDatos() {
    _nombreUsuario.text = SrvDiskette.leerValor(DisketteKey.alias, defaultValue: "");
    _sonidoActivado = SrvDiskette.leerValor(DisketteKey.sonidoActivado, defaultValue: true);
    _musicaActivada = SrvDiskette.leerValor(DisketteKey.musicaActivada, defaultValue: true);
  }

  void _guardarDatos(BuildContext pContexto) async {
    SrvDiskette.guardarValor(DisketteKey.alias, _nombreUsuario.text);
    SrvDiskette.guardarValor(DisketteKey.sonidoActivado, _sonidoActivado);
    SrvDiskette.guardarValor(DisketteKey.musicaActivada, _musicaActivada);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Datos correctamente guardados')));
    await Future.delayed(const Duration(milliseconds: 100));
    await SrvSonidos.goback();
    await Future.delayed(const Duration(milliseconds: 250));
    if (pContexto.mounted) {
      Navigator.pop(pContexto);
    }
  }
}
