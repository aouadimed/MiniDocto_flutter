import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/schedule_screen/presentation/bloc/schedule_bloc.dart';
import 'package:flutter_user/features/schedule_screen/presentation/pages/schedule_screen.dart';
import 'package:flutter_user/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/appointment.dart';
import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue.shade600,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(appointment.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(appointment.startTime.toLocal()),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('HH:mm').format(appointment.startTime)} - ${DateFormat('HH:mm').format(appointment.endTime)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_canRescheduleOrCancel(appointment.status))
                  TextButton(
                    onPressed: () {
                      // Log reschedule appointment action
                      FirebaseAnalytics.instance.logEvent(
                        name: 'reschedule_appointment_clicked',
                        parameters: {
                          'appointment_id': appointment.id,
                          'doctor_id': appointment.doctorId,
                          'doctor_name': appointment.doctorName,
                          'current_status': appointment.status,
                          'timestamp': DateTime.now().toIso8601String(),
                        },
                      );
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create: (context) => sl<ScheduleBloc>(),
                                child: ScheduleScreen(
                                  doctorId: appointment.doctorId,
                                ),
                              ),
                        ),
                      );
                    },
                    child: Text(
                      'Reschedule',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                if (_canRescheduleOrCancel(appointment.status))
                  const SizedBox(width: 8),
                if (_canRescheduleOrCancel(appointment.status))
                  TextButton(
                    onPressed: () {
                      // Log cancel appointment dialog shown
                      FirebaseAnalytics.instance.logEvent(
                        name: 'cancel_appointment_dialog_shown',
                        parameters: {
                          'appointment_id': appointment.id,
                          'doctor_id': appointment.doctorId,
                          'doctor_name': appointment.doctorName,
                          'appointment_status': appointment.status,
                          'timestamp': DateTime.now().toIso8601String(),
                        },
                      );
                      
                      _showCancelConfirmationDialog(context);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canRescheduleOrCancel(String status) {
    final normalizedStatus = status.toLowerCase();
    // Allow reschedule/cancel for all statuses except completed, cancelled, and no-show
    return normalizedStatus != 'completed' &&
        normalizedStatus != 'cancelled' &&
        normalizedStatus != 'no-show';
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: whiteColor,
          title: const Text('Cancel Appointment'),
          content: const Text(
            'Are you sure you want to cancel this appointment? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Keep Appointment',
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                // Log cancel appointment confirmation
                FirebaseAnalytics.instance.logEvent(
                  name: 'cancel_appointment_confirmed',
                  parameters: {
                    'appointment_id': appointment.id,
                    'doctor_id': appointment.doctorId,
                    'doctor_name': appointment.doctorName,
                    'appointment_status': appointment.status,
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                
                Navigator.of(dialogContext).pop();
                try {
                  context.read<AppointmentBloc>().add(
                    CancelAppointment(appointmentId: appointment.id),
                  );
                } catch (e) {
                  final appointmentBloc = sl<AppointmentBloc>();
                  appointmentBloc.add(
                    CancelAppointment(appointmentId: appointment.id),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cancelling appointment...'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cancel Appointment'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'scheduled':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;
      case 'no-show':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
