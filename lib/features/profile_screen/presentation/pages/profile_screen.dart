import 'package:flutter/material.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:flutter_user/core/services/app_routes.dart';
import 'package:flutter_user/global/common_widget/app_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
        titleText: 'Profile',
          logo: AssetImage('assets/images/logo.webp'),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Log logout dialog shown
                FirebaseAnalytics.instance.logEvent(
                  name: 'logout_dialog_shown',
                  parameters: {
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                
                _showLogoutDialog(context);
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child:  Text('Cancel',style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () async {
                // Log logout confirmation
                FirebaseAnalytics.instance.logEvent(
                  name: 'logout_confirmed',
                  parameters: {
                    'user_email': TokenManager.userEmail ?? 'unknown',
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                
                Navigator.of(dialogContext).pop();
                await TokenManager.logout();
                
                // Log successful logout
                FirebaseAnalytics.instance.logEvent(
                  name: 'logout_completed',
                  parameters: {
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, loginScreen);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}