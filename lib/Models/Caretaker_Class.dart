import 'dart:convert';

CaretakerInfo CaretakerInfoFromJson(String str) => CaretakerInfo.fromJson(json.decode(str));

String CaretakerInfoToJson(CaretakerInfo data) => json.encode(data.toJson());

class CaretakerList {
  final List<CaretakerInfo> Caretaker;

  CaretakerList({
    required this.Caretaker,
  });

  factory CaretakerList.fromJson(Map<String, dynamic> json) => CaretakerList(
    Caretaker: List<CaretakerInfo>.from(
        json["caretakers"].map((x) => CaretakerInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'caretakers': List<dynamic>.from(Caretaker.map((x) => x.toJson()))
  };
}

class CaretakerInfo {
  final int caretaker_id;
  final String name;
  final String username;
  final String email;
  final String contact;
  final String password;
  final int? patient_id;

  CaretakerInfo({
    required this.caretaker_id,
    required this.name,
    required this.username,
    required this.email,
    required this.contact,
    required this.password,
    required this.patient_id,
  });

  factory CaretakerInfo.fromJson(Map<String, dynamic> json) => CaretakerInfo(
      caretaker_id: json["caretaker_id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      contact: json["contact"],
      password: json["password"],
      patient_id: json["patient_id"]
  );

  Map<String, dynamic> toJson() => {
    'caretaker_id': caretaker_id,
    'name': name,
    'username': username,
    'email': email,
    'contact': contact,
    'password': password,
    'patient_id': patient_id
  };
}
