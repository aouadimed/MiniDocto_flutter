import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/schedule_screen/presentation/utils/time_slot_style.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../domain/entities/schedule_group.dart';
import '../../domain/entities/time_slot.dart';
import '../bloc/schedule_bloc.dart';

class TimeSlotsSection extends StatelessWidget {
  final ScheduleGroup selectedGroup;
  final String? selectedTimeSlotId;

  const TimeSlotsSection({
    super.key,
    required this.selectedGroup,
    required this.selectedTimeSlotId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SectionTitle(),
            const SizedBox(height: 16),

            // Morning slots
            if (selectedGroup.morningSlots.isNotEmpty) ...[
              _TimeSlotGroup(
                title: 'Morning',
                slots: selectedGroup.morningSlots,
                selectedTimeSlotId: selectedTimeSlotId,
              ),
              const SizedBox(height: 16),
            ],

            // Afternoon slots
            if (selectedGroup.afternoonSlots.isNotEmpty)
              _TimeSlotGroup(
                title: 'Afternoon',
                slots: selectedGroup.afternoonSlots,
                selectedTimeSlotId: selectedTimeSlotId,
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Available Time Slots',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _TimeSlotGroup extends StatelessWidget {
  final String title;
  final List<TimeSlot> slots;
  final String? selectedTimeSlotId;

  const _TimeSlotGroup({
    required this.title,
    required this.slots,
    required this.selectedTimeSlotId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final style = TimeSlotChipStyle.fromWidth(screenWidth);
    
    // Calculate number of columns based on screen width
    final columns = screenWidth > 600 ? 4 : 2;
    final itemWidth = (screenWidth - 32 - ((columns - 1) * style.spacing)) / columns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: style.spacing,
            mainAxisSpacing: style.spacing,
            childAspectRatio: itemWidth / 40, // Fixed height of 48
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = slot.id == selectedTimeSlotId;
            
            return GestureDetector(
              onTap: (slot.isAvailable && !slot.isPast)
                  ? () {
                      // Log time slot selection
                      FirebaseAnalytics.instance.logEvent(
                        name: 'select_time_slot',
                        parameters: {
                          'slot_id': slot.id,
                          'slot_time': slot.time,
                          'slot_period': slot.period,
                          'slot_type': title.toLowerCase(), // morning or afternoon
                          'timestamp': DateTime.now().toIso8601String(),
                        },
                      );
                      
                      context.read<ScheduleBloc>().add(
                        SelectTimeSlot(slot.id),
                      );
                    }
                  : null,
              child: Container(
                height: 48, // Fixed height
                decoration: BoxDecoration(
                  color: _getBackgroundColor(slot, isSelected),
                  border: Border.all(
                    color: _getBorderColor(slot, isSelected),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        slot.time,
                        style: TextStyle(
                          fontSize: style.fontSize,
                          fontWeight: FontWeight.w500,
                          color: _getTextColor(slot, isSelected),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (slot.isBookedByUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.shade700,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getBackgroundColor(TimeSlot slot, bool isSelected) {
    if (slot.isPast) {
      return Colors.grey.shade100;
    } else if (slot.isBookedByUser) {
      return Colors.green.shade100;
    } else if (!slot.isAvailable) {
      return Colors.grey.shade200;
    } else if (isSelected) {
      return primaryColor;
    } else {
      return Colors.white;
    }
  }

  Color _getBorderColor(TimeSlot slot, bool isSelected) {
    if (slot.isPast) {
      return Colors.grey.shade300;
    } else if (slot.isBookedByUser) {
      return Colors.green.shade400;
    } else if (!slot.isAvailable) {
      return Colors.grey.shade300;
    } else if (isSelected) {
      return primaryColor;
    } else {
      return primaryColor.withOpacity(0.3);
    }
  }

  Color _getTextColor(TimeSlot slot, bool isSelected) {
    if (slot.isPast) {
      return Colors.grey.shade400;
    } else if (slot.isBookedByUser) {
      return Colors.green.shade700;
    } else if (!slot.isAvailable) {
      return Colors.grey.shade500;
    } else if (isSelected) {
      return Colors.white;
    } else {
      return primaryColor;
    }
  }
}
