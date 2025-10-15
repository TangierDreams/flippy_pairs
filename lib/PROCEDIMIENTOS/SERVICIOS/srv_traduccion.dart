import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_globales.dart';

class SrvTraduccion {
  static final Map<String, String> english = {
    'subtitulo_app': 'Harden Your Mind Once and for All!',
    'configuracion': 'Settings...',
    'comenzar_juego': 'Start Playing!',
    'temas': 'Themes',
    'dificultad': 'Difficulty',
    'texto_alias': 'Please enter the alias you wish to use in the Flippy World Competition...',
    'alias': 'Alias',
    'alias_hint': 'Enter a name you like...',
    'activar_sonidos': 'Turn Sounds On or Off...',
    'activar_musica': 'Turn Music On of Off...',
    'grabar_datos': 'Save Data',
    'datos_guardados': 'Data saved successfully',
    'puntos': 'Points',
    'aciertos': 'Match',
    'errores': 'Fail',
    'timer': 'Timer',
  };

  static final Map<String, String> spanish = {
    'subtitulo_app': 'Endurece tu mente de una vez por todas!',
    'configuracion': 'Configuración...',
    'comenzar_juego': 'Jugar!',
    'temas': 'Temas',
    'dificultad': 'Dificultad',
    'texto_alias': 'Por favor, introduce el alias con el que quieres aparecer en la Competición Mundial Flippy...',
    'alias': 'Alias',
    'alias_hint': 'Introduce un nombre que te guste...',
    'activar_sonidos': 'Activar o desactivar sonidos...',
    'activar_musica': 'Activar o desactivar música...',
    'grabar_datos': 'Guardar datos',
    'datos_guardados': 'Datos guardados correctamente',
    'puntos': 'Puntos',
    'aciertos': 'OK',
    'errores': 'KO',
    'timer': 'Timer',
  };

  static String get(String pId) {
    String output = '';
    switch (DatosGenerales.idioma) {
      case 'es':
        output = spanish[pId] == null ? pId : spanish[pId]!;
        break;
      default:
        output = english[pId] == null ? pId : english[pId]!;
    }
    return output;
  }
}
