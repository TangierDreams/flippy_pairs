import 'package:flutter/material.dart';

class AppGeneral {
  static const String title = "Flippy Pairs";
  static const String logo = "assets/images/app_logo.png";
}

class AppColors {
  static const Color primary = Colors.indigo;
  static const Color contrast = Colors.white;
  static const Color accent = Colors.amber;
  static final Color background = Colors.grey.shade300;
  static final Color fontColor = Colors.grey.shade800;
}

class AppTexts {
  static final TextStyle subtitle = TextStyle(
    fontSize: 20,
    color: AppColors.contrast,
  );

  static final TextStyle normal = TextStyle(
    fontSize: 14,
    color: AppColors.fontColor,
  );

  static final TextStyle highlighted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.fontColor,
  );

  static final TextStyle buttonDisabled = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}
