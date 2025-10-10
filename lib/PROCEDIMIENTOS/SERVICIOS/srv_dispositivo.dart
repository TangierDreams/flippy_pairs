//------------------------------------------------------------------------------
// Obtenemos el id del dispositivo y si no tenemos ninguno, creamos uno nuevo.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:uuid/uuid.dart';

class SrvDispositivo {
  static final Uuid _uuid = Uuid();

  static Future<String> obtenerId() async {
    // Miramos si ya tenemos un id del dispositivo:

    String existingDeviceId = SrvDiskette.leerValor(DisketteKey.deviceId, defaultValue: "");

    if (existingDeviceId != "") {
      return existingDeviceId;
    }

    // Si no lo tenemos, lo creamos y nos lo guardamos:

    String newDeviceId = _uuid.v4(); // Generates a unique ID
    SrvDiskette.guardarValor(DisketteKey.deviceId, newDeviceId);

    return newDeviceId;
  }
}
