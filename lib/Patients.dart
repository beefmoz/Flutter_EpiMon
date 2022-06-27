import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path/path.dart';
import 'package:epimon2/Models/Doctors_Class.dart';

import 'package:epimon2/BackgroundCollectingTask.dart';
import './ChatPage.dart';
import './SelectBondedDevicePage.dart';
import 'package:epimon2/api_manager.dart';

import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'Models/Doctors_Class.dart';


class PatientPage extends StatefulWidget {
  final String username;
  const PatientPage({required this.username});
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Your Information")
      ),
      body: Container(
        child: FutureBuilder<List<PatientInfo>>(
          future: API_Manager().getPatientsList(),
          builder: (context, snapshot) {
            return FutureBuilder<List<DoctorInfo>>(
                future: API_Manager().getDoctorsList(),
                builder: (context, snapshot2) {
                  String name= '';
                  String username= '';
                  String email= '';
                  int age= 0;
                  String contact= '';
                  int patientid= 0;
                  int doctorid= 0;

                  String doctorusername='';
                  String doctoremail='';
                  // int verified= 0;
                  // String status='';
                  // String password='';
                  // String role='';
                  if(snapshot.hasData && snapshot2.hasData) {
                    //print("have data");
                    for (int i=0; i<snapshot.data!.length; i++) {
                      if(widget.username== snapshot.data![i].username){
                        name= snapshot.data![i].name;
                        username= snapshot.data![i].username;
                        email= snapshot.data![i].email;
                        age= snapshot.data![i].age;
                        contact= snapshot.data![i].contact;
                        patientid= snapshot.data![i].patient_id;
                        doctorid= snapshot.data![i].doctor_id;
                      }
                    }
                    for (int x=0; x<snapshot2.data!.length; x++) {
                      if(doctorid== snapshot2.data![x].user_id){
                        doctorusername= snapshot2.data![x].username;
                        doctoremail= snapshot2.data![x].email;
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Name', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(name),
                                      ),
                                      ListTile(
                                        title: const Text('Email', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(email),
                                      ),
                                      ListTile(
                                        title: const Text('Age', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(age.toString()),
                                      ),
                                      ListTile(
                                        title: const Text('Contact', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(contact),
                                      ),
                                      ListTile(
                                        title: const Text('Your Patient ID', style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(patientid.toString()),
                                      ),
                                      ListTile(
                                        title: const Text("Your Doctor's name", style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        )),
                                        subtitle: Text(doctorusername),
                                      ),
                                      ListTile(
                                        title: const Text("Your Doctor's email", style: TextStyle(
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
                  } else if(snapshot.hasError || snapshot2.hasError)
                    print("error patient or doctor");
                    //print(snapshot.error?.toString());
                    print(snapshot2.error?.toString());
                  return Center(child: CircularProgressIndicator());
                },
            );
          }
        ),
      ),
    );
  }
}

