import 'package:flippy_pairs/PROCEDIMIENTOS/WIDGETS/wid_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para TextInputFormatter

class PagConfiguracion extends StatefulWidget {
  const PagConfiguracion({super.key});

  @override
  State<PagConfiguracion> createState() => _PagConfiguracionState();
}

class _PagConfiguracionState extends State<PagConfiguracion> {
  final TextEditingController _nameController = TextEditingController();

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
            TextField(
              controller: _nameController,
              // 1. Usamos inputFormatters para aplicar restricciones al input
              inputFormatters: [
                // LengthLimitingTextInputFormatter limita el número de caracteres
                LengthLimitingTextInputFormatter(25),
              ],
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce un nombre (máx. 25 caracteres)',
                // Muestra un contador de caracteres
                //counterText: '${_nameController.text.length} / $_maxLength',
                border: const OutlineInputBorder(),
              ),
              // Opcional: Para actualizar el contador cada vez que se escribe
              //onChanged: (text) {
              // El setState fuerza a la interfaz a redibujar y actualizar el counterText
              //setState(() {
              // Esto no es estrictamente necesario para el límite,
              // pero es útil para actualizar el contador de caracteres visual
              //});
              //},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para procesar el nombre
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Nombre guardado: ${_nameController.text}')));
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
