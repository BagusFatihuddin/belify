import 'package:flutter/material.dart';

class SnackbarUtil {
  static void show(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
