import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Only format when the value is not empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-numeric characters
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Initialize formatted text
    String formattedText = newText;

    // Format as hh:mm
    if (newText.length > 2) {
      formattedText = '${newText.substring(0, 2)}:${newText.substring(2)}';
    }

    // Validate and correct hours and minutes
    final parts = formattedText.split(':');
    if (parts.length == 2) {
      final hours = int.tryParse(parts[0]);
      final minutes = int.tryParse(parts[1]);

      if (hours != null && (hours < 0 || hours > 23)) {
        formattedText = '23:${parts[1]}';
      }
      if (minutes != null && (minutes < 0 || minutes > 59)) {
        formattedText = '${parts[0]}:59';
      }
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
