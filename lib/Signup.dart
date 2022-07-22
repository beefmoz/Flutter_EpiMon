import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';

import 'package:http/http.dart' as http;
import 'package:epimon2/Login.dart';

import 'Models/Doctors_Class.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FNameController = TextEditingController();
  final UNameController = TextEditingController();
  final EmailController = TextEditingController();
  final ContactController = TextEditingController();
  final AgeController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  final CaretakerController = TextEditingController();
  late final int success = 0;

  final List<String>doctors = [

  ];

  final List<String>caretakers = [

  ];
  String? value;
  String? caretaker;
  int? docid=0;
  int? careid=0;
  int prevpatientid=0;
  int currpatientid=0;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: const Text('EpiMon'),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<List<DoctorInfo>> (
                future: API_Manager().getDoctorsList(),
                builder: (context, snapshot) {
                  return FutureBuilder<List<CaretakerInfo>>(
                      future: API_Manager().getCaretakersList(),
                      builder: (context, snapshot2) {
                        return FutureBuilder<List<PatientInfo>> (
                            future: API_Manager().getPatientsList(),
                            builder: (context, snapshot3) {
                              doctors.clear();
                              caretakers.clear();
                              String dropdownvalue = 'docA';
                              if (snapshot.data == null || snapshot2.data == null || snapshot3.data == null) {
                                // print('error: ');
                                // print(snapshot.error?.toString());
                                // print(snapshot2.error?.toString());
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              else {
                                prevpatientid= snapshot3.data!.last.patient_id;
                                currpatientid= prevpatientid+1;
                                for (var i in snapshot.data!) {
                                  doctors.add(i.username.toString());
                                  if (value == i.username.toString()) {
                                    docid = i.user_id;
                                  }
                                }
                                caretaker= CaretakerController.text;
                                for (var c in snapshot2.data!) {
                                  caretakers.add(c.name.toString());
                                  if (caretaker == c.name.toString()) {
                                    careid = c.caretaker_id;
                                  }
                                  // print('caretaker: ');
                                  // print(careid);
                                }

                                return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height + 150,
                                    width: double.infinity,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(height:15),
                                          Column(
                                            children: <Widget>[
                                              Text('Sign Up',
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                              ),
                                              SizedBox(height: 15),
                                              Text('Create an account as a patient',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 15,
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Column(
                                              children: <Widget>[
                                                inputFile(label: "Full name",
                                                    controller: FNameController),

                                                inputFile(label: "Preferred Username",
                                                    controller: UNameController),

                                                inputFile(
                                                    label: "Email",
                                                    controller: EmailController),

                                                inputFile(label: "Contact",
                                                    controller: ContactController),

                                                inputFile(label: "Age",
                                                    controller: AgeController),

                                                inputFile(label: "Caretaker's name",
                                                    controller: CaretakerController),

                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("Doctor's name",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black87,

                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 16, 0, 16),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: 4),
                                                    borderRadius: BorderRadius
                                                        .circular(5),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    value: value,
                                                    isExpanded: true,
                                                    items: doctors.map(buildMenuItem)
                                                        .toList(),
                                                    onChanged:
                                                        (value) =>
                                                        setState(() =>
                                                        this.value = value),
                                                  ),
                                                ),


                                                inputFile(label: "Password",
                                                    controller: PasswordController,
                                                    obscureText: true),

                                                inputFile(label: "Confirm Password",
                                                    controller: ConfirmPasswordController,
                                                    obscureText: true),
                                              ]
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 3),

                                              child: MaterialButton(
                                                minWidth: double.infinity,
                                                height: 60,
                                                onPressed: () {
                                                  int succ = 0;
                                                  String pw = PasswordController.text;
                                                  String conpw = ConfirmPasswordController
                                                      .text;
                                                  if (pw == conpw) {
                                                    succ = 1;
                                                    addPatients(docid!, careid!, currpatientid);
                                                  }
                                                  else {
                                                    succ = 0;
                                                  }
                                                  setState(() {});
                                                  showAlertDialog(context, succ);
                                                  // print(value);
                                                  // print(docid);
                                                },
                                                color: Colors.blue,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      50),

                                                ),
                                                child: Text("Sign Up",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text("Already have an account?"),
                                              Text(' Login ',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  )
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ]

                                    )

                                );
                              }
                      }
                  );
                }
                );
        }

    )
    )

    );}

  DropdownMenuItem<String> buildMenuItem(String doctor) => DropdownMenuItem(
    value: doctor,
    child: Text(doctor, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
  );

  addPatients(int doc, int care, int currpatientid) async {
    String fname = FNameController.text;
    String uname = UNameController.text;
    String email = EmailController.text;
    String contact = ContactController.text;
    String age = AgeController.text;
    String pw = PasswordController.text;
    String conpw = ConfirmPasswordController.text;
    var doctid= doc;
    var caretid= care;
    String jsonString='';

    if (pw == conpw) {
      Map<String, dynamic> jsonMp1 = {
        "name": '"' + fname + '"',
        "username": '"' + uname + '"',
        "email": '"' + email + '"',
        "contact": '"' + contact + '"',
        "age": age,
        "password": '"' + pw + '"',
        "doctor_id": '"'+doctid.toString()+'"',
        "caretaker_id": '"'+caretid.toString()+'"',
        "update_query": 'UPDATE caretakers SET patient_id = "' + currpatientid.toString() + '"WHERE caretaker_id= "' + caretid.toString() + '";'
      };

      Map<String, dynamic> jsonMp2 = {
        "name": '"' + fname + '"',
        "username": '"' + uname + '"',
        "email": '"' + email + '"',
        "contact": '"' + contact + '"',
        "age": age,
        "password": '"' + pw + '"',
        "doctor_id": '"'+doctid.toString()+'"',
        "caretaker_id": 'null',
        "update_query": '"0"'
      };
      if (caretid!=0) {
        jsonString = json.encode(jsonMp1);
      }
      else if (caretid==0) {
        jsonString = json.encode(jsonMp2);
      }
      // print(jsonString);
      try {
        var response = await http.post(
            Uri.parse(
                'http://aspepilepsyproject.atspace.cc/access/addPatients.php'),
            body: jsonString
        );
        // print(response.body);
        // print(response.statusCode);
      } catch (e) {
        // print("Error");
        // print(e);
      }
    }
    else {

    }
  }

  showAlertDialog(BuildContext context, int success) {
    // Create button
    Widget successButton = RaisedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      },
    );

    Widget failedButton = RaisedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertSuccess = AlertDialog(
      title: Text("Register Successful!"),
      content: Text("Your new account has been registered. You may now login!"),
      actions: [
        successButton,
      ],
    );

    AlertDialog alertFailed = AlertDialog(
      title: Text("Register Failed!"),
      content: Text("Check your details again!"),
      actions: [
        failedButton,
      ],
    );

    // show the dialog
    if(success==1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertSuccess;
        },
      );
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertFailed;
        },
      );
    }

  }

}
