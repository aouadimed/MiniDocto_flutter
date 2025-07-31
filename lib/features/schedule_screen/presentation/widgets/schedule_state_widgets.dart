import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import '../bloc/schedule_bloc.dart';

class ScheduleLoadingState extends StatelessWidget {
  
  const ScheduleLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ScheduleErrorState extends StatelessWidget {
  final String doctorId;
  final ScheduleError error;

  const ScheduleErrorState({
    super.key,
    required this.error,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ErrorIcon(isNetworkError: error.isNetworkError),
            const SizedBox(height: 16),
            _ErrorTitle(isNetworkError: error.isNetworkError),
            const SizedBox(height: 8),
            _ErrorMessage(message: error.message),
            const SizedBox(height: 16),
            _RetryButton(doctorId: doctorId,),
          ],
        ),
      ),
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  final bool isNetworkError;

  const _ErrorIcon({required this.isNetworkError});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isNetworkError ? Icons.wifi_off : Icons.error_outline,
      size: 64,
      color: Colors.grey[400],
    );
  }
}

class _ErrorTitle extends StatelessWidget {
  final bool isNetworkError;

  const _ErrorTitle({required this.isNetworkError});

  @override
  Widget build(BuildContext context) {
    return Text(
      isNetworkError 
          ? 'No internet connection' 
          : 'Something went wrong',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600]),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final String doctorId;

  const _RetryButton({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                  
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
      onPressed: () {
        context.read<ScheduleBloc>().add(
           LoadScheduleGroups(isRefresh: true, doctorId: doctorId),
        );
      },
      child: const Text('Retry'),
    );
  }
}
