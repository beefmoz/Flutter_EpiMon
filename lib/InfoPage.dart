

import 'package:flutter/material.dart';
import 'package:epimon2/Models/Doctors_Class.dart';

import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';
import 'Models/Doctors_Class.dart';

class InfoPage extends StatefulWidget {
  final String username;
  final String role;
  const InfoPage({required this.username, required this.role});
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    if (widget.role=='patient') {
      return Scaffold(
        appBar: AppBar(
            title: Text("Your Information")
        ),
        body: Container(
          child: FutureBuilder<List<PatientInfo>>(
              future: API_Manager().getPatientsList(),
              builder: (context, Patient) {
                return FutureBuilder<List<DoctorInfo>>(
                future: API_Manager().getDoctorsList(),
                builder: (context, Doctor) {
                return FutureBuilder<List<CaretakerInfo>>(
                  future: API_Manager().getCaretakersList(),
                  builder: (context, Caretaker) {
                    String name = '';
                    String username = '';
                    String email = '';
                    int age = 0;
                    String contact = '';
                    int patientid = 0;
                    int doctorid = 0;
                    int? caretakerid=0;

                    String doctorusername = '';
                    String doctoremail = '';

                    String caretakername = '';
                    // int verified= 0;
                    // String status='';
                    // String password='';
                    // String role='';

                    if (!Patient.hasData || !Doctor.hasData ||
                        !Caretaker.hasData) {
                      // print(l.error?.toString());
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (Patient.hasData && Doctor.hasData) {
                      //print("have data");
                      for (int i = 0; i < Patient.data!.length; i++) {
                        if (widget.username == Patient.data![i].username) {
                          name = Patient.data![i].name;
                          username = Patient.data![i].username;
                          email = Patient.data![i].email;
                          age = Patient.data![i].age;
                          contact = Patient.data![i].contact;
                          patientid = Patient.data![i].patient_id;
                          caretakerid = Patient.data![i].caretaker_id;
                          doctorid = Patient.data![i].doctor_id;
                        }
                      }
                      for (int x = 0; x < Doctor.data!.length; x++) {
                        if (doctorid == Doctor.data![x].user_id) {
                          doctorusername = Doctor.data![x].username;
                          doctoremail = Doctor.data![x].email;
                        }
                      }
                      for (int x = 0; x < Caretaker.data!.length; x++) {
                        if (caretakerid == Caretaker.data![x].caretaker_id) {
                          caretakername = Caretaker.data![x].name;
                        }
                      }
                      return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            //var patient = snapshot.data?.patients[index];
                            return Container(
                              height: 700,
                              margin: const EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ListTile(
                                          title: const Text(
                                              'Name', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(name),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Email', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(email),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Age', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(age.toString()),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Contact', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(contact),
                                        ),
                                        // ListTile(
                                        //   title: const Text('Your Patient ID',
                                        //       style: TextStyle(
                                        //           fontSize: 18,
                                        //           fontWeight: FontWeight.bold
                                        //       )),
                                        //   subtitle: Text(patientid.toString()),
                                        // ),
                                        // ListTile(
                                        //   title: const Text("Your Caretaker's ID",
                                        //       style: TextStyle(
                                        //           fontSize: 18,
                                        //           fontWeight: FontWeight.bold
                                        //       )),
                                        //   subtitle: Text(caretakerid.toString()),
                                        // ),
                                        ListTile(
                                          title: const Text("Your Caretaker's name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(caretakername.toString()),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              "Your Doctor's name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(doctorusername),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              "Your Doctor's email",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(doctoremail),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                    else if (Patient.hasError || Doctor.hasError || Caretaker.hasError)
                      print("error patient or doctor");
                      //print(snapshot.error?.toString());
                      //print(Doctor.error?.toString());
                      return Center(child: CircularProgressIndicator());

                  });
                }
                );
              }),
        )
    );
    }
    else {
      return Scaffold(
        appBar: AppBar(
            title: Text("Your Information")
        ),
        body: Container(
          child: FutureBuilder<List<CaretakerInfo>>(
              future: API_Manager().getCaretakersList(),
              builder: (context, Caretaker) {
                return FutureBuilder<List<PatientInfo>>(
                  future: API_Manager().getPatientsList(),
                  builder: (context, Patient) {
                    String name = '';
                    String username = '';
                    String email = '';
                    int age = 0;
                    String contact = '';
                    int? patientid = 0;
                    int caretakerid = 0;

                    String Patientname = '';
                    String Patientemail = '';
                    // int verified= 0;
                    // String status='';
                    // String password='';
                    // String role='';
                    if (Caretaker.hasData && Patient.hasData) {
                      //print("have data");
                      for (int i = 0; i < Caretaker.data!.length; i++) {
                        if (widget.username == Caretaker.data![i].username) {

                          name = Caretaker.data![i].name;
                          username = Caretaker.data![i].username;
                          email = Caretaker.data![i].email;
                          contact = Caretaker.data![i].contact;
                          patientid = Caretaker.data![i].patient_id;
                          caretakerid = Caretaker.data![i].caretaker_id;
                        }
                      }
                      for (int x = 0; x < Patient.data!.length; x++) {
                        if (patientid == Patient.data![x].patient_id) {
                          Patientname = Patient.data![x].name;
                          Patientemail = Patient.data![x].email;
                        }
                      }
                      return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            //var patient = snapshot.data?.patients[index];
                            return Container(
                              height: 600,
                              margin: const EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ListTile(
                                          title: const Text(
                                              'Name', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(name),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Email', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(email),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              'Contact', style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          )),
                                          subtitle: Text(contact),
                                        ),
                                        ListTile(
                                          title: const Text("Your Caretaker ID",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(caretakerid.toString()),
                                        ),
                                        ListTile(
                                          title: const Text("Your Patient's ID",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(patientid.toString()),
                                        ),
                                        ListTile(
                                          title: const Text(
                                              "Your Patient's name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(Patientname),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else if (Caretaker.hasError || Patient.hasError)
                      // print("error patient or doctor");
                    //print(snapshot.error?.toString());
                    print(Patient.error?.toString());
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
          ),
        ),
      );
    }
  }
}
