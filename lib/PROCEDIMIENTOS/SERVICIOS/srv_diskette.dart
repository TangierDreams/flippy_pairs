import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diskette {
  //==============================================================================
  // VARIABLES GLOBALES PARA SHARED PREFERENCES
  //==============================================================================

  static const String _nombreDiskette = 'flippy_pairs';
  static Map<String, dynamic> _datos = {};
  static bool _inicializado = false;

  // ============================================================================
  // FUNCIONES DE INICIALIZACIÓN Y CARGA
  // ============================================================================

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
        _datos = json.decode(jsonData) as Map<String, dynamic>;
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

  static dynamic leerValor(String clave, {dynamic defaultValue}) {
    return _datos[clave] ?? defaultValue;
  }

  // Verifica si existe una clave

  static bool existeClave(String clave) {
    return _datos.containsKey(clave);
  }

  // Obtiene todas las claves guardadas

  static List<String> obtenerClaves() {
    return _datos.keys.toList();
  }

  // Obtiene todos los datos como mapa

  static Map<String, dynamic> obtenerMapaDeDatos() {
    return Map<String, dynamic>.from(_datos);
  }

  // ============================================================================
  // FUNCIONES DE ESCRITURA
  // ============================================================================

  // Guarda un valor (crea si no existe, actualiza si existe)

  static Future<void> guardarValor(String clave, dynamic valor) async {
    _datos[clave] = valor;
    await _guardarEnDisco();
  }

  // Elimina una clave

  static Future<void> eliminarClave(String clave) async {
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
