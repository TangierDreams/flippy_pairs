import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//------------------------------------------------------------------------------
// Posibles claves para el diskette
//------------------------------------------------------------------------------

enum DisketteKey { ciudad, deviceId, deviceName, idPais, nombrePais, puntuacion }

class SrvDiskette {
  //============================================================================
  // VARIABLES GLOBALES PARA SHARED PREFERENCES
  //============================================================================

  static const String _nombreDiskette = 'flippy_pairs';
  static Map<DisketteKey, dynamic> _datos = {};
  static bool _inicializado = false;

  // ===========================================================================
  // FUNCIONES DE INICIALIZACIÓN Y CARGA
  // ===========================================================================

  // Inicializa y carga los datos desde SharedPreferences
  // Llamar desde main.dart antes de usar cualquier otra función

  static Future<void> inicializar() async {
    if (_inicializado) return;

    await _cargarDesdeDiskette();
    _inicializado = true;
  }

  /// Carga los datos del disco a memoria
  ///
  static Future<void> _cargarDesdeDiskette() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_nombreDiskette);

    if (jsonData != null) {
      try {
        _datos = json.decode(jsonData) as Map<DisketteKey, dynamic>;
      } catch (e) {
        debugPrint('Error cargando datos: $e');
        _datos = {};
      }
    } else {
      _datos = {};
    }
  }

  // ============================================================================
  // FUNCIONES DE LECTURA
  // ============================================================================

  // Lee un valor del disco
  // Devuelve defaultValue si la clave no existe

  static dynamic leerValor(DisketteKey clave, {dynamic defaultValue}) {
    return _datos[clave] ?? defaultValue;
  }

  // Verifica si existe una clave

  static bool existeClave(DisketteKey clave) {
    return _datos.containsKey(clave);
  }

  // Obtiene todas las claves guardadas

  static List<DisketteKey> obtenerClaves() {
    return _datos.keys.toList();
  }

  // Obtiene todos los datos como mapa

  static Map<DisketteKey, dynamic> obtenerMapaDeDatos() {
    return Map<DisketteKey, dynamic>.from(_datos);
  }

  // ============================================================================
  // FUNCIONES DE ESCRITURA
  // ============================================================================

  // Guarda un valor (crea si no existe, actualiza si existe)

  static Future<void> guardarValor(DisketteKey clave, dynamic valor) async {
    _datos[clave] = valor;
    await _guardarEnDisco();
  }

  // Elimina una clave

  static Future<void> eliminarClave(DisketteKey clave) async {
    _datos.remove(clave);
    await _guardarEnDisco();
  }

  // Borra todos los datos

  static Future<void> borrarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nombreDiskette);
    _datos = {};
  }

  // ============================================================================
  // FUNCIÓN INTERNA PARA GUARDAR EN DISCO
  // ============================================================================

  static Future<void> _guardarEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_datos);
    await prefs.setString(_nombreDiskette, jsonString);
  }
}
