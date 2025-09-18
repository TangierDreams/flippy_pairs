import 'package:flutter/material.dart';

class ModDrawerOption {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ModDrawerOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}