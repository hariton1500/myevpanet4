import 'package:flutter/material.dart';

showScaffoldMessage({required String message, required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
