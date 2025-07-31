import 'package:flutter/material.dart';
import 'package:flutter_user/core/constants/appcolors.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const ContinueButton({
    super.key,
    required this.onPressed,
    this.text = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
