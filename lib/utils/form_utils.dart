import 'package:flutter/material.dart';

Widget buildRequiredLabel(String labelText) {
  return RichText(
    text: TextSpan(
      text: labelText,
      style: const TextStyle(color: Colors.black),
      children: const [
        TextSpan(
          text: ' *',
          style: TextStyle(color: Colors.red),
        ),
      ],
    ),
  );
}

Widget buildRequiredTextLabel(String text, {TextStyle? style}) {
  return RichText(
    text: TextSpan(
      text: text,
      style:
          style ??
          const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
      children: const [
        TextSpan(
          text: ' *',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
