import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';

import 'api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';

import 'package:http/http.dart' as http;
import 'package:epimon2/Login.dart';

class SignupCaretakerPage extends StatefulWidget {
  @override
  _SignupCaretakerPageState createState() => _SignupCaretakerPageState();
}

class _SignupCaretakerPageState extends State<SignupCaretakerPage> {
  final FNameController = TextEditingController();
  final UNameController = TextEditingController();
  final EmailController = TextEditingController();
  final ContactController = TextEditingController();
  final PasswordController = TextEditingController();
  final PatientController= TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  late final int success = 0;
  int prevCaretakerid=0;
  int currCaretakerid=0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: const Text('Epilepsy Warning System'),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<List<PatientInfo>> (
              future: API_Manager().getPatientsList(),
                builder: (context, snapshot) {

                  return FutureBuilder<List<CaretakerInfo>>(
                      future: API_Manager().getCaretakersList(),
                      builder: (context, snapshot2) {
                        if (snapshot.data == null || snapshot2.data == null) {
                          // print('error: ');
                          // print(snapshot.error?.toString());
                          // print(snapshot2.error?.toString());
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Container (
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height - 50,
                        width: double.infinity,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Sign Up',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  Text('Create an account as a caretaker',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15,
                                      )
                                  ),
                                ],
                              ),
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

                                    inputFile(label: "Patient's full name",
                                        controller: PatientController),

                                    inputFile(label: "Password",
                                        controller: PasswordController,
                                        obscureText: true),

                                    inputFile(label: "Confirm Password",
                                        controller: ConfirmPasswordController,
                                        obscureText: true),
                                  ]
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 5, left: 3),
                                  // decoration:
                                  // BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(50),
                                  //   border: Border(
                                  //     bottom: BorderSide(color: Colors.black),
                                  //     top: BorderSide(color: Colors.black),
                                  //     left: BorderSide(color: Colors.black),
                                  //     right: BorderSide(color: Colors.black),
                                  //   ),
                                  // ),
                                  child: MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: () {
                                      prevCaretakerid= snapshot2.data!.last.caretaker_id;
                                      currCaretakerid= prevCaretakerid+1;
                                      int patientid= 0;
                                      int succ = 0;
                                      String pw = PasswordController.text;
                                      String conpw = ConfirmPasswordController
                                          .text;
                                      if (pw == conpw) {
                                        succ = 1;
                                        for (var i in snapshot.data!) {
                                          if (PatientController.text==i.name) {
                                            patientid= i.patient_id;
                                          }
                                        }
                                        addCaretaker(patientid, currCaretakerid);
                                      }
                                      else {
                                        succ = 0;
                                      }
                                      setState(() {});
                                      showAlertDialog(context, succ);
                                    },
                                    color: Colors.blue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),

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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              )
                            ]

                        )

                    );
                  }
            );
          }
        )
    )
    );
  }

  addCaretaker(int patientid, int currCaretakerid) async {
    String fname = FNameController.text;
    String uname = UNameController.text;
    String email = EmailController.text;
    String contact = ContactController.text;
    String pw = PasswordController.text;
    String conpw = ConfirmPasswordController.text;
    String jsonString='';

    if (pw == conpw) {
      Map<String, dynamic>jsonMp1 = {
          "name": '"' + fname + '"',
          "username": '"' + uname + '"',
          "email": '"' + email + '"',
          "contact": '"' + contact + '"',
          "password": '"' + pw + '"',
          "patient_id": '"' + patientid.toString() + '"',
          "update_query": 'UPDATE patients SET caretaker_id = "' + currCaretakerid.toString() + '" WHERE patient_id= "' + patientid.toString() + '";'
        };

      Map<String, dynamic>jsonMp2 = {
          "name": '"' + fname + '"',
          "username": '"' + uname + '"',
          "email": '"' + email + '"',
          "contact": '"' + contact + '"',
          "password": '"' + pw + '"',
          "patient_id": 'null',
          "update_query": "0",
        };
        if (patientid!=0) {
          jsonString = json.encode(jsonMp1);
        }
        else if (patientid==0) {
          jsonString = json.encode(jsonMp2);
        }
        // print('jsonString: ');
        // print(jsonString);
        try {
          var response = await http.post(
              Uri.parse(
                  'http://aspepilepsyproject.atspace.cc/access/addCaretakers.php'),
              body: jsonString
          );
          // print(response.body);
          // print(response.statusCode);
        }
        catch (e) {
          // print("Error");
          // print(e);
        }
        }
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
