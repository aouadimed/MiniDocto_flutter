import 'package:intl/intl.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import '../../domain/entities/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.id,
    required super.time,
    required super.isAvailable,
    required super.period,
    required super.isPast,
    required super.isBookedByUser,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    // Convert to local time
    final startTime = DateTime.parse(json['startTime'] as String).toLocal();
    final endTime = DateTime.parse(json['endTime'] as String).toLocal();

    // Check if time slot is in the past
    final now = DateTime.now().toLocal();
    final isPast = startTime.isBefore(now);

    // Check if booked by current user
    final currentUserEmail = TokenManager.userEmail;
    final bookedByEmail = json['bookedByEmail'] as String?;
    final isBookedByUser =
        currentUserEmail != null &&
        bookedByEmail != null &&
        currentUserEmail == bookedByEmail;

    // Format as "hh:mm AM/PM"
    final formatter = DateFormat('hh:mm a');
    final formattedRange =
        '${formatter.format(startTime)} - ${formatter.format(endTime)}';

    return TimeSlotModel(
      id: json['id'] as String,
      time: formattedRange,
      isAvailable: json['status'] == 'AVAILABLE' && !isPast,
      period: _determinePeriod(startTime.hour),
      isPast: isPast,
      isBookedByUser: isBookedByUser,
    );
  }

  static String _determinePeriod(int hour) {
    return hour < 12 ? 'morning' : 'afternoon';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'isAvailable': isAvailable,
      'period': period,
      'isPast': isPast,
      'isBookedByUser': isBookedByUser,
    };
  }
}
