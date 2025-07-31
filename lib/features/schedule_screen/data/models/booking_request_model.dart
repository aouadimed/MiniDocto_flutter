import '../../domain/entities/booking_request.dart';

class BookingRequestModel extends BookingRequest {
  const BookingRequestModel({
    required super.doctorId,
    required super.slotId,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'slotId': slotId,
    };
  }
}

class BookingResponseModel extends BookingResponse {
  const BookingResponseModel({
    required super.id,
    required super.doctorId,
    required super.slotId,
    required super.status,
    required super.message,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    return BookingResponseModel(
      id: data?['id'] as String? ?? '',
      doctorId: data?['doctorId'] as String? ?? '',
      slotId: data?['slotId'] as String? ?? '',
      status: data?['status'] as String? ?? '',
      message: json['message'] as String? ?? 'Appointment booked successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'slotId': slotId,
      'status': status,
      'message': message,
    };
  }
}
