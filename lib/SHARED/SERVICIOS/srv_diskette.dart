import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//==============================================================================
// VARIABLES GLOBALES PARA SHARED PREFERENCES
//==============================================================================

const String _nombreDiskette = 'flippy_pairs';
Map<String, dynamic> _datos = {};
bool _inicializado = false;

// ============================================================================
// FUNCIONES DE INICIALIZACIÓN Y CARGA
// ============================================================================

// Inicializa y carga los datos desde SharedPreferences
// Llamar desde main.dart antes de usar cualquier otra función

Future<void> disketteInicializar() async {
  if (_inicializado) return;

  await _cargarDesdeDiskette();
  _inicializado = true;
}

/// Carga los datos del disco a memoria
Future<void> _cargarDesdeDiskette() async {
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

/// Lee un valor del disco
/// Devuelve defaultValue si la clave no existe

dynamic disketteLeerValor(String clave, {dynamic defaultValue}) {
  return _datos[clave] ?? defaultValue;
}

/// Verifica si existe una clave
bool disketteExisteClave(String clave) {
  return _datos.containsKey(clave);
}

/// Obtiene todas las claves guardadas
List<String> disketteObtenerClaves() {
  return _datos.keys.toList();
}

/// Obtiene todos los datos como mapa
Map<String, dynamic> disketteObtenerMapaDeDatos() {
  return Map<String, dynamic>.from(_datos);
}

// ============================================================================
// FUNCIONES DE ESCRITURA
// ============================================================================

// Guarda un valor (crea si no existe, actualiza si existe)

Future<void> disketteGuardarValor(String clave, dynamic valor) async {
  _datos[clave] = valor;
  await _guardarEnDisco();
}

// Elimina una clave

Future<void> disketteEliminarClave(String clave) async {
  _datos.remove(clave);
  await _guardarEnDisco();
}

// Borra todos los datos

Future<void> disketteBorrarTodo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_nombreDiskette);
  _datos = {};
}

// ============================================================================
// FUNCIÓN INTERNA PARA GUARDAR EN DISCO
// ============================================================================

Future<void> _guardarEnDisco() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(_datos);
  await prefs.setString(_nombreDiskette, jsonString);
}
