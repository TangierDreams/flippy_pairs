import 'package:intl/intl.dart';

class Fechas {
  //----------------------------------------------------------------------------
  // Devolvemos la fecha actual en formato yyyy-mm-dd:
  //----------------------------------------------------------------------------
  static String hoyEnYYYYMMDD() {
    final DateFormat formateador = DateFormat('yyyy-MM-dd');
    final DateTime ahora = DateTime.now();
    return formateador.format(ahora);
  }
}
