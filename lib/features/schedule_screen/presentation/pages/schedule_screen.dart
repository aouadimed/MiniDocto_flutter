import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/schedule_screen/presentation/utils/responsive_utils.dart';
import 'package:flutter_user/features/schedule_screen/presentation/bloc/schedule_bloc.dart';
import 'package:flutter_user/features/schedule_screen/presentation/widgets/continue_button.dart';
import 'package:flutter_user/features/schedule_screen/presentation/widgets/schedule_groups_grid.dart';
import 'package:flutter_user/features/schedule_screen/presentation/widgets/schedule_state_widgets.dart';
import 'package:flutter_user/features/schedule_screen/presentation/widgets/time_slots_section.dart';
import 'package:flutter_user/features/schedule_screen/presentation/widgets/schedule_shimmer_widget.dart';
import 'package:flutter_user/global/common_widget/app_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ScheduleScreen extends StatefulWidget {
  final String doctorId;
  const ScheduleScreen({super.key, required this.doctorId});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    // Log viewing schedule screen
    FirebaseAnalytics.instance.logEvent(
      name: 'view_doctor_schedule',
      parameters: {
        'doctor_id': widget.doctorId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    context.read<ScheduleBloc>().add(
      LoadScheduleGroups(doctorId: widget.doctorId),
    );
  }

  void _loadNextPage() {
    final state = context.read<ScheduleBloc>().state;
    if (state is ScheduleLoaded && state.hasMorePages && !state.isLoadingMore) {
      context.read<ScheduleBloc>().add(
        LoadScheduleGroups(
          page: state.currentPage + 1,
          doctorId: widget.doctorId,
        ),
      );
    }
  }

  void _handleContinue() {
    final state = context.read<ScheduleBloc>().state;
    if (state is ScheduleLoaded &&
        state.selectedGroupId != null &&
        state.selectedTimeSlotId != null) {
      _showBookingConfirmationDialog(state);
    }
  }

  void _showBookingConfirmationDialog(ScheduleLoaded state) {
    final selectedGroup = state.scheduleGroups.firstWhere(
      (group) => group.id == state.selectedGroupId,
    );
    final selectedSlot = selectedGroup.timeSlots.firstWhere(
      (slot) => slot.id == state.selectedTimeSlotId,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to book this appointment?'),
              const SizedBox(height: 16),
              Text(
                'Date: ${selectedGroup.dateRange}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Time: ${selectedSlot.time} ${selectedSlot.period}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                // Log booking confirmation
                FirebaseAnalytics.instance.logEvent(
                  name: 'confirm_appointment_booking',
                  parameters: {
                    'doctor_id': widget.doctorId,
                    'slot_id': state.selectedTimeSlotId!,
                    'date_range': selectedGroup.dateRange,
                    'time_slot': '${selectedSlot.time} ${selectedSlot.period}',
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                
                Navigator.of(dialogContext).pop();
                // Trigger booking
                context.read<ScheduleBloc>().add(
                  BookAppointment(
                    doctorId: widget.doctorId,
                    slotId: state.selectedTimeSlotId!,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Appointment'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              // Log successful booking
              FirebaseAnalytics.instance.logEvent(
                name: 'appointment_booked_successfully',
                parameters: {
                  'doctor_id': widget.doctorId,
                  'booking_message': state.message,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back or to success screen
              Navigator.of(context).pop();
            } else if (state is BookingError) {
              // Log booking failure
              FirebaseAnalytics.instance.logEvent(
                name: 'appointment_booking_failed',
                parameters: {
                  'doctor_id': widget.doctorId,
                  'error_message': state.message,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              return switch (state) {
                ScheduleLoading() => Shimmer(
                  duration: const Duration(seconds: 3),
                  interval: const Duration(seconds: 5),
                  color: Colors.white,
                  colorOpacity: 0.3,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: const ScheduleShimmerWidget(),
                ),
                ScheduleError() => ScheduleErrorState(
                  error: state,
                  doctorId: widget.doctorId,
                ),
                ScheduleLoaded() => _buildLoadedContent(state),
                BookingInProgress() => const _BookingLoadingState(),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return const GeneralAppBar(titleText: "Book Appointment");
  }

  Widget _buildLoadedContent(ScheduleLoaded state) {
    // Calculate adaptive spacing based on available items
    final itemCount = state.scheduleGroups.length;
    final spacingBetweenSections =
        itemCount <= 3 ? 8.0 : 16.0; // Reduced spacing for fewer items
    return state.scheduleGroups.isEmpty
        ? _emptyStateWidget()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: spacingBetweenSections),
            _buildScheduleGroupsSection(state),
            if (state.selectedGroupId != null) ...[
              SizedBox(height: spacingBetweenSections),
              _buildTimeSlotsSection(state),
            ],
            if (state.selectedTimeSlotId != null) ...[
              SizedBox(
                height: spacingBetweenSections / 2,
              ), // Even smaller spacing before continue button
              _buildContinueSection(),
            ],
          ],
        );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Select Schedule',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildScheduleGroupsSection(ScheduleLoaded state) {
    return SizedBox(
      height: ResponsiveUtils.getScheduleGroupsHeight(
        context,
        state.scheduleGroups.length,
      ),
      child: ScheduleGroupsGrid(
        scheduleGroups: state.scheduleGroups,
        selectedGroupId: state.selectedGroupId,
        isLoadingMore: state.isLoadingMore,
        onLoadMore: _loadNextPage,
      ),
    );
  }

  Widget _buildTimeSlotsSection(ScheduleLoaded state) {
    final selectedGroup = state.scheduleGroups.firstWhere(
      (group) => group.id == state.selectedGroupId,
    );

    return Expanded(
      child: TimeSlotsSection(
        selectedGroup: selectedGroup,
        selectedTimeSlotId: state.selectedTimeSlotId,
      ),
    );
  }

  Widget _buildContinueSection() {
    return ContinueButton(onPressed: _handleContinue);
  }

  Widget _emptyStateWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 30),
          Text(
            'No available schedule',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _BookingLoadingState extends StatelessWidget {
  const _BookingLoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Card(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.all(32),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(height: 16),
                Text(
                  'Booking your appointment...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
