import 'package:flutter/material.dart';
void main() {
  showDatePicker(
    context: null as dynamic,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    cancelText: 'Annuler',
    cancelButtonStyle: const ButtonStyle(),
    confirmButtonStyle: const ButtonStyle(),
  );
}
