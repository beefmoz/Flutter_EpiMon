import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';
import 'package:epimon2/Models/EpilepsyHistory_Class.dart';
import 'package:epimon2/Models/Doctors_Class.dart';

class API_Manager {
  Future<PatientInfo>? getPatient(int i) async {
    var client = http.Client();
    var patient;

    try {

      //String jsonPw= jsonMp.toString();
      Uri url = Uri.http('aspepilepsyproject.atspace.cc', '/jsonPatients.php');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonList = json.decode(jsonString);
        //print(jsonString);
        // print(jsonList[i]);
        patient = PatientInfo.fromJson(jsonList[i]);
        return patient;
      }
    } catch (Exception) {
      print("Exception: ");
      print(Exception);
      return patient;
    }
    return patient;
  }

  Future<DoctorInfo>? getDoctor(int i) async {
    var client = http.Client();
    var Doctor;

    try {

      //String jsonPw= jsonMp.toString();
      Uri url = Uri.http('aspepilepsyproject.atspace.cc', '/jsonUsers.php');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonList = json.decode(jsonString);
        print(jsonString);
        //print(jsonList[i]);
        Doctor = DoctorInfo.fromJson(jsonList[i]);
        return Doctor;
      }
    } catch (Exception) {
      print("Exception: ");
      print(Exception);
      return Doctor;
    }
    return Doctor;
  }

  Future<History>? getHistory(int i) async {
    var client = http.Client();
    var history;

    try {
      Uri url = Uri.http('aspepilepsyproject.atspace.cc', '/jsonHistories.php');

      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonList = json.decode(jsonString);
        print(jsonString);
        print(jsonList[i]);
        history = PatientInfo.fromJson(jsonList[i]);
        return history;
      }
    } catch (Exception) {
      print(Exception);
      return history;
    }
    return history;
  }

  Future<List<PatientInfo>> getPatientsList() async {
    Map<String, dynamic> jsonPw= {
      "pword": "kumbarfanclubx68"
    };
    String jsonStringPw= json.encode(jsonPw);
    //print(jsonStringPw);
    List<PatientInfo> patients = [];
    var response = await http.post(Uri.parse('http://aspepilepsyproject.atspace.cc/jsonPatients.php'),
        body: jsonStringPw
    );
    if(response.statusCode==200) {
      //print(response.statusCode);
      //print(response.body);
      var jsonData = json.decode(response.body);
      // print(jsonData);
      for (var u in jsonData) {
        PatientInfo p = PatientInfo(
          patient_id: u["patient_id"],
          name: u["name"],
          username: u["username"],
          email: u["email"],
          contact: u["contact"],
          age: u["age"],
          password: u["password"],
          doctor_id: u["doctor_id"],
          caretaker_id: u["caretaker_id"],
        );
        patients.add(p);
      }
    }
    //print(patients.length);
    return patients;
  }

  Future<List<History>> getHistoryData() async {
    List<History> histories = [];
    var response = await http.get(Uri.http('aspepilepsyproject.atspace.cc', '/jsonHistories.php'));
    if(response.statusCode==200) {
      //print(response.statusCode);
      //print(response.body);
      var jsonData = json.decode(response.body);
      //print(jsonData);
      for (var u in jsonData) {
        // print(u);
        History p = History(
          id: u["id"],
          Stress: u["Stress"].toDouble(),
          AccelerometerX: u["AccelerometerX"].toDouble(),
          AccelerometerY: u["AccelerometerY"].toDouble(),
          AccelerometerZ: u["AccelerometerZ"].toDouble(),
          HeartRate: u["HeartRate"].toDouble(),
          timestart: u["timestart"],
          timestop: u["timestop"],
          Gyroscopic_Changes: u["Gyroscopic_Changes"].toDouble(),
          patient_id: u["patient_id"],
          heartrate_history: u["heartrate_history"],
        );
        histories.add(p);
      }
    }
    //print(histories.length);
    return histories;
  }

  Future<List<DoctorInfo>> getDoctorsList() async {
    Map<String, dynamic> jsonPw= {
      "pword": "kumbarfanclubx68"
    };
    String jsonStringPw= json.encode(jsonPw);
    //print(jsonStringPw);
    List<DoctorInfo> doctors = [];
    var response = await http.post(Uri.parse('http://aspepilepsyproject.atspace.cc/jsonUsers.php'),
        body: jsonStringPw
    );
    if(response.statusCode==200) {
      // print(response.statusCode);
      // print(response.body);
      var jsonData = json.decode(response.body);
      // print('jsondata: ');
      //print(jsonData);
      for (var u in jsonData) {
        DoctorInfo d = DoctorInfo(
          user_id: u["user_id"],
          username: u["username"],
          email: u["email"],
          verified: u["verified"],
          password: u["password"],
          status: u["status"],
          role: u["role"],
        );
        doctors.add(d);
      }
    }
    //print(doctors.length);
    return doctors;
  }

  Future<List<CaretakerInfo>> getCaretakersList() async {
    Map<String, dynamic> jsonPw= {
      "pword": "kumbarfanclubx68"
    };
    String jsonStringPw= json.encode(jsonPw);
    //print(jsonStringPw);
    List<CaretakerInfo> Caretakers = [];
    var response = await http.post(Uri.parse('http://aspepilepsyproject.atspace.cc/jsonCaretakers.php'),
        body: jsonStringPw
    );
    if(response.statusCode==200) {
      //print(response.statusCode);
      //print(response.body);
      var jsonData = json.decode(response.body);
      //print('jsondata: ');
      //print(jsonData);
      for (var u in jsonData) {
        if(u["patient_id"]==null) {
          CaretakerInfo d = CaretakerInfo(
            caretaker_id: u["caretaker_id"],
            name: u["name"],
            username: u["username"],
            email: u["email"],
            contact: u["contact"],
            password: u["password"],
            patient_id: 0,
          );
        }
        CaretakerInfo d = CaretakerInfo(
          caretaker_id: u["caretaker_id"],
          name: u["name"],
          username: u["username"],
          email: u["email"],
          contact: u["contact"],
          password: u["password"],
          patient_id: u["patient_id"],
        );
        Caretakers.add(d);
      }
    }
    //print(doctors.length);
    return Caretakers;
  }

}