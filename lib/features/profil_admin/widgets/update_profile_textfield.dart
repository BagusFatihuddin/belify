import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration(String label, Color color) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: color),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

class UpdateProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color primaryColor;
  final TextInputType? keyboardType;
  final int maxLines;

  const UpdateProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.primaryColor,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(),
        decoration: inputDecoration(label, primaryColor),
      ),
    );
  }
}
