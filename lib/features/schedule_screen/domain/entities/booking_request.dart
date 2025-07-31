import 'package:equatable/equatable.dart';

class BookingRequest extends Equatable {
  final String doctorId;
  final String slotId;

  const BookingRequest({
    required this.doctorId,
    required this.slotId,
  });

  @override
  List<Object?> get props => [doctorId, slotId];
}

class BookingResponse extends Equatable {
  final String id;
  final String doctorId;
  final String slotId;
  final String status;
  final String message;

  const BookingResponse({
    required this.id,
    required this.doctorId,
    required this.slotId,
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [id, doctorId, slotId, status, message];
}
