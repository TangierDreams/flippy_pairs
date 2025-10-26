import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';

class SrvTraducciones {
  static final Map<String, String> english = {
    'subtitulo_app': 'Harden Your Mind Once and for All!',
    'configuracion': 'Settings...',
    'comenzar_juego': 'Start Playing!',
    'temas': 'Themes',
    'dificultad': 'Difficulty',
    'texto_alias': 'Please enter the alias you wish to use in the FWC (Flippy World Competition)...',
    'alias': 'Alias',
    'alias_hint': 'Enter a name you like...',
    'activar_sonidos': 'Turn Sounds On or Off...',
    'activar_musica': 'Turn Music On or Off...',
    'grabar_datos': 'Save Data',
    'datos_guardados': 'Data saved successfully',
    'puntos': 'Points',
    'aciertos': 'Match',
    'errores': 'Fail',
    'timer': 'Timer',
    'excelente': '🎉 Excellent!',
    'ops': '😅 Oooppss!',
    'empate': '🎯 In the middle!',
    'has_ganado': "You've won ### points in this game. Congratulations!",
    'has_perdido': "You've lost ### points in this game. You can do it better...",
    'has_empatado': "No points gained… no points lost. Just in the middle! Give it another go!",
    'puntuacion_total': 'Your total score:',
    'finalizado_en': 'Game finished in:',
    'volver_a_jugar': 'Play again',
    'salir': 'Exit',
    'fin_del_juego': 'End of Game',
    'tiempo_medio': 'Average time of others:',
    'partidas_jugadas': 'Matches played:',
    'tiempo_record': 'Your best time is:',
    'selec_idioma': 'Select a language...',
    'pos_flippy': 'Your ranking in the FWC:',
    'nivel': "Level",
  };

  static final Map<String, String> spanish = {
    'subtitulo_app': 'Endurece tu mente de una vez por todas!',
    'configuracion': 'Configuración...',
    'comenzar_juego': 'Jugar!',
    'temas': 'Temas',
    'dificultad': 'Dificultad',
    'texto_alias':
        'Por favor, introduce el alias con el que quieres aparecer en la CMF (Competición Mundial Flippy)...',
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
    'empate': '🎯 En el medio!',
    'has_ganado': "Has ganado ### puntos en esta partida. Felicidades!",
    'has_perdido': "Has perdido ### puntos en esta partida. Puedes hacerlo mejor...",
    'has_empatado': "Ni puntos ganados ni perdidos. Justo en el medio! Vuelve a intentarlo!",
    'puntuacion_total': 'Puntuación total:',
    'finalizado_en': 'Partida finalizada en:',
    'volver_a_jugar': 'Volver a jugar',
    'salir': 'Salir',
    'fin_del_juego': 'Fin del juego',
    'tiempo_medio': 'Tiempo medio de otros:',
    'partidas_jugadas': 'Partidas jugadas:',
    'tiempo_record': 'Tu tiempo record es:',
    'selec_idioma': "Selecciona un idioma...",
    'pos_flippy': 'Tu ranking en la CMF:',
    'nivel': "Nivel",
  };

  static final Map<String, String> catalan = {
    'subtitulo_app': "Endureix la teva ment d'una vegada per totes!",
    'configuracion': 'Configuració...',
    'comenzar_juego': 'Juga!',
    'temas': 'Temes',
    'dificultad': 'Dificultat',
    'texto_alias': "Si us plau, introdueix l'àlies amb el qual vols aparèixer a la CMF (Competició Mundial Flippy)...",
    'alias': 'Àlies',
    'alias_hint': "Introdueix un nom que t'agradi...",
    'activar_sonidos': 'Activar o desactivar sons...',
    'activar_musica': 'Activar o desactivar música...',
    'grabar_datos': 'Desar dades',
    'datos_guardados': 'Dades desades correctament',
    'puntos': 'Punts',
    'aciertos': 'OK',
    'errores': 'KO',
    'timer': 'Timer',
    'excelente': '🎉 Excel·lent!',
    'ops': '😅 Oooppss!',
    'empate': '🎯 Just al mig!',
    'has_ganado': "Has guanyat ### punts en aquesta partida. Felicitats!",
    'has_perdido': "Has perdut ### punts en aquesta partida. Pots fer-ho millor...",
    'has_empatado': "Ni punts guanyats ni perduts. Just al mig! Torna a jugar!",
    'puntuacion_total': 'Puntuació total:',
    'finalizado_en': 'Partida finalitzada en:',
    'volver_a_jugar': 'Torna a jugar',
    'salir': 'Surt',
    'fin_del_juego': 'Fi del joc',
    'tiempo_medio': 'Temps mitjà dels altres:',
    'partidas_jugadas': 'Partides jugades:',
    'tiempo_record': 'El teu temps rècord és:',
    'selec_idioma': "Tria un idioma...",
    'pos_flippy': 'El teu ranking a la CMF',
    'nivel': "Nivell",
  };

  //----------------------------------------------------------------------------
  // Obtenemos una traducción.
  //----------------------------------------------------------------------------

  static String get(String pId, {String pArgumento = ''}) {
    String output = '';
    String idioma = SrvDiskette.leerValor(DisketteKey.idioma, defaultValue: 'en');
    switch (idioma) {
      case 'es':
        output = spanish[pId] == null ? pId : spanish[pId]!;
        break;
      case 'ca':
        output = catalan[pId] == null ? pId : catalan[pId]!;
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
