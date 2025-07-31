class TimeSlot {
  final String id;
  final String time;
  final bool isAvailable;
  final String period;
  final bool isPast;
  final bool isBookedByUser;

  const TimeSlot({
    required this.id,
    required this.time,
    required this.isAvailable,
    required this.period,
    required this.isPast,
    required this.isBookedByUser,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.id == id &&
        other.time == time &&
        other.isAvailable == isAvailable &&
        other.period == period &&
        other.isPast == isPast &&
        other.isBookedByUser == isBookedByUser;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        time.hashCode ^
        isAvailable.hashCode ^
        period.hashCode ^
        isPast.hashCode ^
        isBookedByUser.hashCode;
  }
}
