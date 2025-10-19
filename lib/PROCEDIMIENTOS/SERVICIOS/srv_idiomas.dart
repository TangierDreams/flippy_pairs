import 'package:flippy_pairs/PROCEDIMIENTOS/SERVICIOS/srv_diskette.dart';
import 'package:flutter/material.dart';

class SrvIdiomas {
  static final ValueNotifier<String> idiomaSeleccionado = ValueNotifier<String>('en');

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
    'puntuacion_total': 'Your total score in this level',
    'finalizado_en': 'Game finished in',
    'volver_a_jugar': 'Play again',
    'salir': 'Exit',
    'fin_del_juego': 'End of Game',
    'tiempo_medio': 'Average time for other people to complete this level',
    'partidas_jugadas':
        'Matches you'
        've played in this level',
    'tiempo_record': 'Your best time in this level is',
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
    'tiempo_medio': 'Tiempo medio de otros para completar este nivel',
    'partidas_jugadas': 'Partidas jugadas en este nivel',
    'tiempo_record': 'Tu record en este nivel es',
  };

  static final Map<String, String> catalan = {
    'subtitulo_app': 'Endureix la teva ment d\'una vegada per totes!',
    'configuracion': 'Configuració...',
    'comenzar_juego': 'Juga!',
    'temas': 'Temes',
    'dificultad': 'Dificultat',
    'texto_alias': 'Si us plau, introdueix l\'àlies amb el qual vols aparèixer a la Competició Mundial Flippy...',
    'alias': 'Àlies',
    'alias_hint': 'Introdueix un nom que t\'agradi...',
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
    'has_ganado': "Has guanyat ### punts en aquesta partida. Felicitats!",
    'has_perdido': "Has perdut ### punts en aquesta partida. Pots fer-ho millor...",
    'puntuacion_total': 'Puntuació total en aquest nivell',
    'finalizado_en': 'Partida finalitzada en',
    'volver_a_jugar': 'Torna a jugar',
    'salir': 'Surt',
    'fin_del_juego': 'Fi del joc',
    'tiempo_medio': 'Temps mitjà dels altres per completar aquest nivell',
    'partidas_jugadas': 'Partides jugades en aquest nivell',
    'tiempo_record': 'El teu rècord en aquest nivell és',
  };

  // Cargar idioma desde disco

  static Future<void> inicializar() async {
    final valor = await SrvDiskette.leerValor(DisketteKey.idioma, defaultValue: 'en');
    idiomaSeleccionado.value = valor;
  }

  // Guardar y notificar idioma

  static Future<void> cambiarIdioma(String nuevoIdioma) async {
    await SrvDiskette.guardarValor(DisketteKey.idioma, nuevoIdioma);
    idiomaSeleccionado.value = nuevoIdioma; // 🔔 Notifica el cambio de idioma
  }

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
