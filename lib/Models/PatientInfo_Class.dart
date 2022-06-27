// To parse this JSON data, do
//
//     final patientInfo = patientInfoFromJson(jsonString);

import 'dart:convert';

PatientInfo patientInfoFromJson(String str) => PatientInfo.fromJson(json.decode(str));

String patientInfoToJson(PatientInfo data) => json.encode(data.toJson());

class PatientList {
  final List<PatientInfo> patients;

  PatientList({
    required this.patients,
  });

  factory PatientList.fromJson(Map<String, dynamic> json) => PatientList(
    patients: List<PatientInfo>.from(
        json["patients"].map((x) => PatientInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'patients': List<dynamic>.from(patients.map((x) => x.toJson()))
  };
}

class PatientInfo {
  final int patient_id;
  final String name;
  final String username;
  final String email;
  final String contact;
  final int age;
  final String password;
  final int doctor_id;
  final int? caretaker_id;

  PatientInfo({
    required this.patient_id,
    required this.name,
    required this.username,
    required this.email,
    required this.contact,
    required this.age,
    required this.password,
    required this.doctor_id,
    required this.caretaker_id
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
      patient_id: json["patient_id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      contact: json["contact"],
      age: json["age"],
      password: json["password"],
      doctor_id: json["doctor_id"],
      caretaker_id: json["caretaker_id"]
  );

  Map<String, dynamic> toJson() => {
    'patient_id': patient_id,
    'name': name,
    'username': username,
    'email': email,
    'contact': contact,
    'age': age,
    'password': password,
    'doctor_id': doctor_id,
    'caretaker_id': caretaker_id
  };
}
