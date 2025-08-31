import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1937),
      lastDate: DateTime(2076),
      initialDate: DateTime.now());

  return pickedDate;
}
