import 'package:flutter/material.dart';
import 'package:flutter_user/global/common_widget/app_bar.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: GeneralAppBar(
        titleText: 'Inbox',
          logo: AssetImage('assets/images/logo.webp'),
        ),);
  }
}