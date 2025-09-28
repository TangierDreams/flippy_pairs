//------------------------------------------------------------------------------
// Obtenemos el id del dispositivo y si no tenemos ninguno, creamos uno nuevo.
//------------------------------------------------------------------------------

import 'package:flippy_pairs/SHARED/SERVICES/srv_diskette.dart';
import 'package:uuid/uuid.dart';

class SrvDeviceId {
  static final Uuid _uuid = Uuid();

  static Future<String> getDeviceId() async {
    // Initialize diskette service
    // await SrvDiskette.init();

    // Try to get existing device ID
    String existingDeviceId = SrvDiskette.get("deviceId", defaultValue: "");

    if (existingDeviceId != "") {
      return existingDeviceId;
    }

    // Create new device ID
    String newDeviceId = _uuid.v4(); // Generates a unique ID
    await SrvDiskette.set("deviceId", value: newDeviceId);

    return newDeviceId;
  }
}
