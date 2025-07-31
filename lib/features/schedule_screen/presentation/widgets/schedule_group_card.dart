import 'package:flutter/material.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import '../../domain/entities/schedule_group.dart';

class ScheduleGroupCard extends StatelessWidget {
  final ScheduleGroup scheduleGroup;
  final bool isSelected;
  final VoidCallback onTap;

  const ScheduleGroupCard({
    super.key,
    required this.scheduleGroup,
    required this.isSelected,
    required this.onTap,
  });
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  // Responsive font sizes and padding.
  double dateFontSize;
  double countFontSize;
  EdgeInsets badgePadding;

  if (screenWidth >= 1024) {
    dateFontSize = 13;
    countFontSize = 11;
    badgePadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
  } else if (screenWidth >= 768) {
    dateFontSize = 12;
    countFontSize = 10;
    badgePadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
  } else if (screenWidth >= 430) {
    dateFontSize = 12;
    countFontSize = 10;
    badgePadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  } else {
    dateFontSize = 11;
    countFontSize = 9.5;
    badgePadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                scheduleGroup.dateRange,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: dateFontSize,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? primaryColor : Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
          ),
          Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${scheduleGroup.availableCount}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: countFontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}