import 'package:flutter/material.dart';
import 'package:flutter_user/features/authentication/presentation/pages/login_screen.dart';
import 'package:flutter_user/features/authentication/presentation/pages/register_screen.dart';
import 'package:flutter_user/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_user/features/my_appointment_screen/presentation/pages/my_appointment_screen.dart';


const String loginScreen = '/login';
const String registerScreen = '/register';
const String bottomNavigationBar = '/bottomNavigationBar';
const String myAppointmentScreen = '/myAppointments';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginScreen:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case registerScreen:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );
      case bottomNavigationBar:
      return MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      );
    case myAppointmentScreen:
      return MaterialPageRoute(
        builder: (context) => const MyAppointmentScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        ),
      );
  }
}
