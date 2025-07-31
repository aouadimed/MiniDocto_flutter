import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter/material.dart';

class CreateOrHaveAccountSection extends StatelessWidget {
  final Function()? onTap;
  final String? question;
  final String? action;
  const CreateOrHaveAccountSection(
      {super.key,
      required this.onTap,
      required this.question,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question ?? "Already have an account?",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onTap,
          child: Text(
            action ?? "Sign in",
            style: TextStyle(
                color: primaryColor,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
