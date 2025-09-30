//------------------------------------------------------------------------------
// Obtenemos el id del dispositivo y si no tenemos ninguno, creamos uno nuevo.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/SHARED/SERVICIOS/srv_diskette.dart';
import 'package:uuid/uuid.dart';

final Uuid _uuid = Uuid();

Future<String> obtenerIdDispositivo() async {
  // Miramos si ya tenemos un id del dispositivo:

  String existingDeviceId = disketteLeerValor("deviceId", defaultValue: "");

  if (existingDeviceId != "") {
    return existingDeviceId;
  }

  // Si no lo tenemos, lo creamos y nos lo guardamos:

  String newDeviceId = _uuid.v4(); // Generates a unique ID
  disketteGuardarValor("deviceId", newDeviceId);

  return newDeviceId;
}
