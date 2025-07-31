import '../../domain/entities/schedule_group.dart';
import 'time_slot_model.dart';

class ScheduleGroupModel extends ScheduleGroup {
  const ScheduleGroupModel({
    required super.id,
    required super.startDate,
    required super.endDate,
    required super.timeSlots,
    required super.availableCount,
  });

  factory ScheduleGroupModel.fromJson(Map<String, dynamic> json) {
    return ScheduleGroupModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['date'] as String), // API uses 'date' field
      endDate: DateTime.parse(json['date'] as String), // Same date for single day
      timeSlots: (json['timeSlots'] as List<dynamic>)
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList(),
      availableCount: json['availableSlots'] as int, // API uses 'availableSlots'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'timeSlots': timeSlots
          .map((slot) => (slot as TimeSlotModel).toJson())
          .toList(),
      'availableCount': availableCount,
    };
  }
}

class ScheduleGroupsResponse {
  final List<ScheduleGroupModel> scheduleGroups;
  final int currentPage;
  final int totalPages;
  final bool hasMorePages;

  const ScheduleGroupsResponse({
    required this.scheduleGroups,
    required this.currentPage,
    required this.totalPages,
    required this.hasMorePages,
  });

  factory ScheduleGroupsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;
    
    return ScheduleGroupsResponse(
      scheduleGroups: (data['scheduleGroups'] as List<dynamic>)
          .map((group) => ScheduleGroupModel.fromJson(group as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['currentPage'] as int,
      totalPages: pagination['totalPages'] as int,
      hasMorePages: pagination['hasNextPage'] as bool,
    );
  }
}
