import 'dart:convert';
import 'package:flippy_pairs/SHARED/MODELS/mod_diskette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SrvDiskette {
  static const String disketteName = 'flippy_pairs';

  // In-memory cache
  static ModDiskette? modDiskette;
  static bool _isInitialized = false;

  // En main.dart llamamos a esta función para cargar los valores en memoria:

  static Future<void> init() async {
    if (!_isInitialized) {
      await _loadFromStorage();
      _isInitialized = true;
    }
  }

  // Guardamos en memoria los datos que tenemos en Shared Preferences:

  static Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(disketteName);

    if (jsonData != null) {
      try {
        final Map<String, dynamic> dataMap = json.decode(jsonData);
        modDiskette = ModDiskette.fromMap(dataMap);
      } catch (e) {
        debugPrint('Error loading diskette data: $e');
        modDiskette = ModDiskette();
      }
    } else {
      modDiskette = ModDiskette();
    }
  }

  // Guardamos todos los datos en Storage y en memoria:

  static Future<void> saveData(ModDiskette data) async {
    final prefs = await SharedPreferences.getInstance();

    // Update memory
    modDiskette = data;

    // Save to storage
    final disketteJson = json.encode(data.toMap());
    await prefs.setString(disketteName, disketteJson);
  }

  // Leemos un valor de la shared:

  static dynamic get(String key, {dynamic defaultValue}) {
    final value = modDiskette?.get(key);
    return value ?? defaultValue;
  }

  // ✅ GENERIC: Set any value by key (inserts if new, updates if exists)
  static Future<void> set(String key, {dynamic value}) async {
    modDiskette?.set(key, value);
    await _saveToStorage();
  }

  // ✅ GENERIC: Check if key exists
  static bool has(String key) {
    return modDiskette?.has(key) ?? false;
  }

  // ✅ GENERIC: Remove a field
  static Future<void> remove(String key) async {
    modDiskette?.remove(key);
    await _saveToStorage();
  }

  // Get all data
  static ModDiskette? get data => modDiskette;

  // Get all keys
  static List<String> get keys => modDiskette?.keys ?? [];

  // Private method to save to storage
  static Future<void> _saveToStorage() async {
    if (modDiskette != null) {
      final prefs = await SharedPreferences.getInstance();
      final disketteJson = json.encode(modDiskette!.toMap());
      await prefs.setString(disketteName, disketteJson);
    }
  }

  // Clear all data
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(disketteName);
    modDiskette = ModDiskette();
  }
}
