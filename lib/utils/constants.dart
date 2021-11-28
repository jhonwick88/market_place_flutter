import 'package:flutter/material.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blueGrey[900],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
);

InputDecoration styleFloatingInputDecoration(
    String labelText, IconData? iconData, Widget? suffixIcon) {
  return InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
    icon: iconData != null ? Icon(iconData) : null,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelText: labelText,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
}

const List<String> monthlist = [
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "Nopember",
  "Desember"
];

const List<int> yearList = [
  2021,
  2022,
  2023,
  2024,
  2025,
];
