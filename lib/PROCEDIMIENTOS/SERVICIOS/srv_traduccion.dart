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
    'excelente': '🎉 Excellent!',
    'ops': '😅 Oooppss!',
    'has_ganado': "You've won ### points in this game. Congratulations!",
    'has_perdido': "You've lost ### points in this game. You can do it better...",
    'puntuacion_total': 'Your total score for this level is ### points.',
    'finalizado_en': 'You finished the game in ### minutes.',
    'volver_a_jugar': 'Play again',
    'salir': 'Exit',
    'fin_del_juego': 'End of Game',
    'tiempo_medio': 'The average time for other people to complete this level is ### minutes.',
    'partidas_jugadas': 'In this level you have played ### times.',
    'tiempo_record': 'Your best time in this level has been ### minutes.',
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
    'excelente': '🎉 Excelente!',
    'ops': '😅 Oooppss!',
    'has_ganado': "Has ganado ### puntos en esta partida. Felicidades!",
    'has_perdido': "Has perdido ### puntos en esta partida. Puedes hacerlo mejor...",
    'puntuacion_total': 'Puntuación total en este nivel',
    'finalizado_en': 'Partida finalizada en',
    'volver_a_jugar': 'Volver a jugar',
    'salir': 'Salir',
    'fin_del_juego': 'Fin del juego',
    'tiempo_medio': 'Tiempo medio de otra gente',
    'partidas_jugadas': 'Partidas jugadas en este nivel',
    'tiempo_record': 'Tu record en este nivel es',
  };

  static String get(String pId, {String pArgumento = ''}) {
    String output = '';
    switch (DatosGenerales.idioma) {
      case 'es':
        output = spanish[pId] == null ? pId : spanish[pId]!;
        break;
      default:
        output = english[pId] == null ? pId : english[pId]!;
    }
    if (pArgumento != '') {
      output = output.replaceAll('###', pArgumento);
    }

    return output;
  }
}
