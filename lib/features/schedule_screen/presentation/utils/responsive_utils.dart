import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Consider devices with a shortest side ≥ 600 dp as tablets.
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  /// Determines how many columns to show based on common breakpoints.
  static int getCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1440) return 10; // very large desktops/monitors
    if (screenWidth >= 1024) return 7; // desktops or large tablets
    if (screenWidth >= 768) return 6; // tablets and small laptops
    if (screenWidth >= 430) return 5; // large phones/phablets
    return 5; // small phones
  }

  /// Returns a responsive SliverGridDelegate based on screen size.
  static SliverGridDelegate getGridDelegate(
    BuildContext context,
    int itemCount,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = getCrossAxisCount(screenWidth);

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: getChildAspectRatio(context),
    );
  }

  /// Adjusts aspect ratio so cards get wider on bigger screens.
  static double getChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1440) return 3.5; // very wide screens
    if (screenWidth >= 1024) return 3.0; // desktops / large tablets
    if (screenWidth >= 768) return 2.5; // tablets
    if (screenWidth >= 430) return 1.5; // large phones
    if (screenWidth >= 360) return 1.0; // average phones
    return 0.8; // very small phones
  }

  /// Computes the height of the grid container, clamping rows to avoid overflow.
  static double getScheduleGroupsHeight(BuildContext context, int itemCount) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = getCrossAxisCount(screenWidth);
    final aspectRatio = getChildAspectRatio(context);

    // Calculate the number of rows to display (max 2).
    final rowCount = (itemCount / crossAxisCount).ceil().clamp(1, 2);
    // Account for horizontal padding (32) and spacing (12).
    final cardWidth =
        (screenWidth - 32 - ((crossAxisCount - 1) * 12)) / crossAxisCount;
    final cardHeight = cardWidth / aspectRatio;

    // Height of grid = total card heights + spacing between rows.
    return (cardHeight * rowCount) + ((rowCount - 1) * 12);
  }
}
