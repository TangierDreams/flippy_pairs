import 'package:intl/intl.dart';

class SrvFechas {
  //----------------------------------------------------------------------------
  // Devolvemos la fecha actual en formato yyyy-mm-dd:
  //----------------------------------------------------------------------------
  static String hoyEnYYYYMMDD() {
    final DateFormat formateador = DateFormat('yyyy-MM-dd');
    final DateTime ahora = DateTime.now();
    return formateador.format(ahora);
  }

  //----------------------------------------------------------------------------
  // Devolvemos la hora actual en formato hh:mm:ss:
  //----------------------------------------------------------------------------
  static String ahoraEnHHMMSS() {
    final DateTime ahora = DateTime.now();
    return "${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}";
  }

  //----------------------------------------------------------------------------
  // Convertimos un valor en segundos a minutos:segundos.
  //----------------------------------------------------------------------------
  static String segundosAMinutosYSegundos(int pSegundos) {
    int minutos = pSegundos ~/ 60;
    int segundos = pSegundos % 60;
    String sMinutos = minutos.toString().padLeft(2, '0');
    String sSegundos = segundos.toString().padLeft(2, '0');
    return '$sMinutos:$sSegundos';
  }
}
