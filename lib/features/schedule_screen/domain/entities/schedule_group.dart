import 'time_slot.dart';

class ScheduleGroup {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final List<TimeSlot> timeSlots;
  final int availableCount;

  const ScheduleGroup({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.timeSlots,
    required this.availableCount,
  });

  String get dateRange {
    // If it's a single day (startDate == endDate), show just the day
    if (startDate.day == endDate.day && 
        startDate.month == endDate.month && 
        startDate.year == endDate.year) {
      return '${startDate.day} ${_getMonthName(startDate.month)}';
    } else {
      // For date ranges, show start to end
      final start = '${startDate.day} ${_getMonthName(startDate.month)}';
      final end = '${endDate.day} ${_getMonthName(endDate.month)}';
      return '$start to $end';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  List<TimeSlot> get morningSlots => 
      timeSlots.where((slot) => slot.period == 'morning').toList();

  List<TimeSlot> get afternoonSlots => 
      timeSlots.where((slot) => slot.period == 'afternoon').toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduleGroup &&
        other.id == id &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.availableCount == availableCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        availableCount.hashCode;
  }
}
