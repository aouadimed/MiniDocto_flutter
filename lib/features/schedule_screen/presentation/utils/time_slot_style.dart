class TimeSlotChipStyle {
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double spacing;

  const TimeSlotChipStyle({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.spacing,
  });

  static TimeSlotChipStyle fromWidth(double width) {
    if (width >= 1024) {
      return const TimeSlotChipStyle(
        horizontalPadding: 30,
        verticalPadding: 12,
        fontSize: 15,
        spacing: 12,
      );
    } else if (width >= 768) {
      return const TimeSlotChipStyle(
        horizontalPadding: 25,
        verticalPadding: 9,
        fontSize: 13,
        spacing: 12,
      );
    } else if (width >= 430) {
      return const TimeSlotChipStyle(
        horizontalPadding: 16,
        verticalPadding: 8,
        fontSize: 14,
        spacing: 8,
      );
    } else {
      return const TimeSlotChipStyle(
        horizontalPadding: 12,
        verticalPadding: 6,
        fontSize: 12,
        spacing: 6,
      );
    }
  }
}
