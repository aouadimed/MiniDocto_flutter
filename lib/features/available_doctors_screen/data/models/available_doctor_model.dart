import 'dart:convert';

AvailableDoctor availableDoctorFromJson(String str) =>
    AvailableDoctor.fromJson(json.decode(str));

class AvailableDoctor {
  AvailableDoctor({
    required this.availableDoctors,
    required this.currentPage,
    required this.totalPages,
  });

  final List<AvailableDoctorElement> availableDoctors;
  final int? currentPage;
  final int? totalPages;

  factory AvailableDoctor.fromJson(Map<String, dynamic> json) {
    return AvailableDoctor(
      availableDoctors:
          json["availableDoctors"] == null
              ? []
              : List<AvailableDoctorElement>.from(
                json["availableDoctors"]!.map(
                  (x) => AvailableDoctorElement.fromJson(x),
                ),
              ),
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}

class AvailableDoctorElement {
  AvailableDoctorElement({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.experience,
    required this.datetime,
    required this.score,
  });
  final String? id;

  final String? name;
  final String? category;
  final String? image;
  final String? experience;
  final String? datetime;
  final int? score;

  factory AvailableDoctorElement.fromJson(Map<String, dynamic> json) {
    return AvailableDoctorElement(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      image: json["image"],
      experience: json["experience"],
      datetime: json["datetime"],
      score: json["score"]?.toInt(),
    );
  }
}
