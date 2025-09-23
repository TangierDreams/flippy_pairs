import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static final textStyleOrange30 = GoogleFonts.chewy(
      textStyle: const TextStyle(
        fontSize: 30,
        height: 0.7,
        color: Colors.orange,
        shadows: [
          Shadow(
            blurRadius: 4,
            color: Colors.black54,
            offset: Offset(2, 2),
          ),
        ],
      ),
  );

  static final textStyleOrange28 = GoogleFonts.luckiestGuy(
      textStyle: const TextStyle(
        fontSize: 28,
        //height: 0.9,
        color: Colors.orange,
        shadows: [
          Shadow(
            blurRadius: 8,
            color: Colors.black87,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );

  static final textStyleYellow30 = GoogleFonts.chewy(
        textStyle: const TextStyle(
          fontSize: 30,
          height: 0.7,
          color: Colors.yellow,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black54,
              offset: Offset(2, 2),
            ),
          ],
        ),
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 20,
    color: AppColors.contrast,
  );

  static final TextStyle smallSubtitle = TextStyle(
    fontSize: 12,
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
