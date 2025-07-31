import 'package:flutter/material.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import '../../domain/entities/time_slot.dart';

class TimeSlotChip extends StatelessWidget {
  final TimeSlot timeSlot;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeSlotChip({
    super.key,
    required this.timeSlot,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = timeSlot.isAvailable;
    final isPast = timeSlot.isPast;
    final isBookedByUser = timeSlot.isBookedByUser;
    
    // Determine if the slot can be tapped (available and not past)
    final canTap = isAvailable && !isPast;
    
    // Determine styling based on state
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    if (isPast) {
      // Past time slots - grayed out
      backgroundColor = Colors.grey.shade100;
      borderColor = Colors.grey.shade300;
      textColor = Colors.grey.shade400;
    } else if (isBookedByUser) {
      // User's own booking - special styling
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade700;
    } else if (!isAvailable) {
      // Unavailable (booked by others) - grayed out
      backgroundColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade300;
      textColor = Colors.grey.shade500;
    } else if (isSelected) {
      // Selected available slot
      backgroundColor = primaryColor;
      borderColor = primaryColor;
      textColor = Colors.white;
    } else {
      // Available slot
      backgroundColor = Colors.white;
      borderColor = primaryColor.withOpacity(0.3);
      textColor = primaryColor;
    }
    
    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeSlot.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (isBookedByUser) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.green.shade700,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
