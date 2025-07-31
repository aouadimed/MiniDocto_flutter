import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/bloc/available_doctors_screen_bloc.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/pages/available_doctors_screen.dart';
import 'package:flutter_user/features/messaging_screen/presentation/pages/messaging_screen.dart';
import 'package:flutter_user/features/my_appointment_screen/presentation/bloc/appointment_bloc.dart';
import 'package:flutter_user/features/my_appointment_screen/presentation/pages/my_appointment_screen.dart';
import 'package:flutter_user/features/profile_screen/presentation/pages/profile_screen.dart';
import 'package:flutter_user/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BlocProvider(
      create: (context) => sl<AvailableDoctorsScreenBloc>(),
      child: const AvailableDoctorsScreen(),
    ),
    BlocProvider(
      create: (context) => sl<AppointmentBloc>(),
      child: const MyAppointmentScreen(),
    ),
    const MessagingScreen(),
    const ProfilScreen(),
  ];

  void _onTabTapped(int index) {
    // Log navigation between tabs
    final tabNames = ['doctors', 'appointments', 'messaging', 'profile'];
    FirebaseAnalytics.instance.logEvent(
      name: 'bottom_nav_tab_selected',
      parameters: {
        'tab_name': tabNames[index],
        'tab_index': index,
        'previous_tab': tabNames[_currentIndex],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    setState(() {
      _currentIndex = index;
    });
  }

  Icon _getIcon(int index, IconData filledIcon, IconData outlinedIcon) {
    return Icon(_currentIndex == index ? filledIcon : outlinedIcon);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: whiteColor,
          type: BottomNavigationBarType.fixed,
          elevation: 5,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _getIcon(0, Icons.home, Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _getIcon(
                2,
                Icons.calendar_month,
                Icons.calendar_month_outlined,
              ),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: _getIcon(3, Icons.message, Icons.message_outlined),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: _getIcon(4, Icons.person, Icons.person_outline),
              label: 'Profile',
            ),
          ],
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 8),
        ),
      ),
    );
  }
}
