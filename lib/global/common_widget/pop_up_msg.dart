import 'package:flutter/material.dart';
import 'package:flutter_user/core/constants/appcolors.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? redColor,
      content: Text(
        message, // Use the message parameter
      ),
    ),
  );
}
