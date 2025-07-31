import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/features/schedule_screen/presentation/utils/responsive_utils.dart';
import 'package:flutter_user/features/schedule_screen/domain/entities/schedule_group.dart';
import 'package:flutter_user/features/schedule_screen/presentation/bloc/schedule_bloc.dart';
import 'package:flutter_user/features/schedule_screen/presentation/utils/pagination_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'schedule_group_card.dart';

class ScheduleGroupsGrid extends StatelessWidget {
  final List<ScheduleGroup> scheduleGroups;
  final String? selectedGroupId;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const ScheduleGroupsGrid({
    super.key,
    required this.scheduleGroups,
    required this.selectedGroupId,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.extentAfter < 200) {
          onLoadMore();
        }
        return false;
      },
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            PaginationUtils.calculatePageCount(scheduleGroups.length, 10) +
            (isLoadingMore ? 1 : 0),
        itemBuilder: (context, pageIndex) {
          if (PaginationUtils.isLoadingPage(
            pageIndex,
            scheduleGroups.length,
            10,
          )) {
            return const _LoadingIndicator();
          }

          final pageGroups = PaginationUtils.getPageItems(
            scheduleGroups,
            pageIndex,
            10,
          );

          return _ScheduleGroupsPage(
            groups: pageGroups,
            selectedGroupId: selectedGroupId,
          );
        },
      ),
    );
  }
}

class _ScheduleGroupsPage extends StatelessWidget {
  final List<ScheduleGroup> groups;
  final String? selectedGroupId;

  const _ScheduleGroupsPage({
    required this.groups,
    required this.selectedGroupId,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total items for better pagination display
    final totalItemsOnPage = groups.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: ResponsiveUtils.getGridDelegate(
          context,
          totalItemsOnPage,
        ),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final isSelected = group.id == selectedGroupId;

          return ScheduleGroupCard(
            scheduleGroup: group,
            isSelected: isSelected,
            onTap: () {
              // Log schedule group selection
              FirebaseAnalytics.instance.logEvent(
                name: 'select_schedule_group',
                parameters: {
                  'group_id': group.id,
                  'date_range': group.dateRange,
                  'available_count': group.availableCount,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              
              context.read<ScheduleBloc>().add(SelectScheduleGroup(group.id));
            },
          );
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}


