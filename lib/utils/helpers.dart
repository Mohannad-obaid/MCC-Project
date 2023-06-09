
import 'package:flutter/material.dart';

mixin Helpers{
  void showSnackBar({required BuildContext context, required String content, required bool error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}

