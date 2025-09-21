import 'package:flutter/material.dart';

class SrvDialog {
  /// Shows a simple question dialog with 2 buttons
  static Future<void> showQuestionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String negativeText,
    required String positiveText,
    required VoidCallback onPositive,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(negativeText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPositive();
              },
              child: Text(positiveText),
            ),
          ],
        );
      },
    );
  }
}

