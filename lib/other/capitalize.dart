import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalize() {
    try {
      if (isEmpty) return this;
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } catch (e) {
      // ignore: avoid_print
      print("Error in capitalize with \"$this\": $e");
      return this;
    }
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.capitalize(),
      selection: newValue.selection,
    );
  }
}
