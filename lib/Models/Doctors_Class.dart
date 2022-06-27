import 'dart:convert';

DoctorInfo DoctorInfoFromJson(String str) => DoctorInfo.fromJson(json.decode(str));

String DoctorInfoToJson(DoctorInfo data) => json.encode(data.toJson());

class DoctorList {
  final List<DoctorInfo> Doctors;

  DoctorList({
    required this.Doctors,
  });

  factory DoctorList.fromJson(Map<String, dynamic> json) => DoctorList(
    Doctors: List<DoctorInfo>.from(
        json["Doctors"].map((x) => DoctorInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'Doctors': List<dynamic>.from(Doctors.map((x) => x.toJson()))
  };
}

class DoctorInfo {
  final int user_id;
  final String username;
  final String email;
  final int verified;
  final String status;
  final String password;
  final String role;

  DoctorInfo({
    required this.user_id,
    required this.username,
    required this.email,
    required this.verified,
    required this.status,
    required this.password,
    required this.role,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) => DoctorInfo(
      user_id: json["user_id"],
      username: json["username"],
      email: json["email"],
      verified: json["verified"],
      status: json["status"],
      password: json["password"],
      role: json["role"]
  );

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'username': username,
    'email': email,
    'verified': verified,
    'status': status,
    'password': password,
    'role': role,
  };
}