import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/global/common_widget/app_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../injection_container.dart';
import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_card_shimmer.dart';

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Log viewing appointments screen
    FirebaseAnalytics.instance.logEvent(
      name: 'view_my_appointments',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    return BlocProvider(
      create: (context) => sl<AppointmentBloc>()..add(const LoadAppointments()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: GeneralAppBar(
          titleText: 'My Appointments',
          logo: AssetImage('assets/images/logo.webp'),
        ),
        body: const MyAppointmentBody(),
      ),
    );
  }
}

class MyAppointmentBody extends StatefulWidget {
  const MyAppointmentBody({super.key});

  @override
  State<MyAppointmentBody> createState() => _MyAppointmentBodyState();
}

class _MyAppointmentBodyState extends State<MyAppointmentBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<AppointmentBloc>().add(LoadMoreAppointments());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentCancelSuccess) {
          // Log successful appointment cancellation
          FirebaseAnalytics.instance.logEvent(
            name: 'appointment_cancelled_successfully',
            parameters: {
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Reload appointments to reflect the change
          context.read<AppointmentBloc>().add(RefreshAppointments());
        } else if (state is AppointmentError && 
                   state.message.contains('cancel')) {
          // Log failed appointment cancellation
          FirebaseAnalytics.instance.logEvent(
            name: 'appointment_cancellation_failed',
            parameters: {
              'error_message': state.message,
              'timestamp': DateTime.now().toIso8601String(),
            },
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel appointment: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
        if (state is AppointmentLoading) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer(
                duration: const Duration(seconds: 3),
                interval: const Duration(seconds: 5),
                color: Colors.white,
                colorOpacity: 0.3,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
                child: const AppointmentCardShimmer(),
              );
            },
          );
        }

        if (state is AppointmentError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AppointmentBloc>().add(RefreshAppointments());
                  },
                  style: ElevatedButton.styleFrom(
                  
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry',),
                ),
              ],
            ),
          );
        }

        if (state is AppointmentLoaded) {
          if (state.appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No appointments found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your appointments will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: primaryColor,
            elevation: 0,
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<AppointmentBloc>().add(RefreshAppointments());
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount:
                  state.appointments.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.appointments.length) {
                  return Shimmer(
                    duration: const Duration(seconds: 3),
                    interval: const Duration(seconds: 5),
                    color: Colors.white,
                    colorOpacity: 0.3,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: const AppointmentCardShimmer(),
                  );
                }

                return AppointmentCard(appointment: state.appointments[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
        },
      ),
    );
  }
}
