
import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class HistoryList {
  final List<History> histories;

  HistoryList({
    required this.histories,
  });

  factory HistoryList.fromJson(Map<String, dynamic> json) => HistoryList(
    histories: List<History>.from(
        json["histories"].map((x) => History.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'patients': List<dynamic>.from(histories.map((x) => x.toJson()))
  };
}

class History {

  final int id;
  final double Stress;
  final double AccelerometerX;
  final double AccelerometerY;
  final double AccelerometerZ;
  final double HeartRate;
  final String timestart;
  final String timestop;
  final double Gyroscopic_Changes;
  final int patient_id;
  final String heartrate_history;

  History({
    required this.id,
    required this.Stress,
    required this.AccelerometerX,
    required this.AccelerometerY,
    required this.AccelerometerZ,
    required this.HeartRate,
    required this.timestart,
    required this.timestop,
    required this.Gyroscopic_Changes,
    required this.patient_id,
    required this.heartrate_history
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
      id: json["id"],
      Stress: json["Stress"],
      AccelerometerX: json["Stress"],
      AccelerometerY: json["AccelerometerY"],
      AccelerometerZ: json["AccelerometerZ"],
      HeartRate: json["HeartRate"].toDouble(),
      timestart: json["timestart"],
      timestop: json["timestop"],
      Gyroscopic_Changes: json["Gyroscopic_Changes"],
      patient_id: json["patient_id"],
      heartrate_history: json["heartrate_history"]
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'Stress': Stress,
    'AccelerometerX': AccelerometerX,
    'AccelerometerY': AccelerometerY,
    'AccelerometerZ': AccelerometerZ,
    'HeartRate': HeartRate,
    'timestart': timestart,
    'timestop': timestop,
    "Gyroscopic_Changes": Gyroscopic_Changes,
    'patient_id': patient_id,
    'heartrate_history': heartrate_history,
  };
}