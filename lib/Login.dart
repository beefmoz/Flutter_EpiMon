// import 'dart:async';
// import 'dart:convert';
import 'package:epimon2/Signup_caretaker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:epimon2/BackgroundCollectingTask.dart';
// import './ChatPage.dart';
// import './MainPage.dart';
import './reqloc.dart';
// import './SelectBondedDevicePage.dart';
import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/main.dart';

// import 'package:epimon2/Models/EpilepsyHistory_Class.dart';
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';
import 'main.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Future<String> _logged;

  // Future<void> _ensureUserLoggedIn() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String logged = (prefs.getString('logged') ?? '') ;
  //
  //   setState(() {
  //     _logged = prefs.setString('logged', logged).then((bool success) {
  //       return logged;
  //     });
  //   });
  // }

  @override

  void initState(){
    super.initState();
    // initSharedPreferences();
  }

  // initSharedPreferences() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   SharedPreferences preferences= await SharedPreferences.getInstance();
  //   var user= preferences.getString('user');
  //   var role= preferences.getString('role');
  //   var id= preferences.getInt('id');
  //   // print(user);
  //   // print(role);
  //   // print(id);
  //   // print(user);
  // }
  //
  // checkLoggedIn(BuildContext context) async{
  //   SharedPreferences preferences= await SharedPreferences.getInstance();
  //   var user= preferences.getString('user');
  //   var role= preferences.getString('role');
  //   var id= preferences.getInt('id');
  //   if(user!=null && user != '') {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return reqloc(username: user, role: role!, id: id!, succ: 1);
  //         },
  //       ),
  //     );
  //   }
  // }
  void dispose() {
    // Clean up the controller when the widget is disposed.
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // checkLoggedIn(context);
    return WillPopScope(
    onWillPop: () async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LandingPage();
          },
        ),
      );
      return false;
    },
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation:0,
          brightness: Brightness.light,
          title: const Text('EpiMon'),
        ),
        body: Container(
            child: FutureBuilder<List<PatientInfo>>(
                future: API_Manager().getPatientsList(),
                builder: (context, Patients){
                  print('login');
                  return FutureBuilder<List<CaretakerInfo>>(
                      future: API_Manager().getCaretakersList(),
                      builder: (context, Caretaker) {
                          if (Patients.data == null || Caretaker.data == null) {
                            print(Patients.error?.toString());
                            print(Caretaker.error?.toString());
                            return Container(
                              child: Center(child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Expanded(child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Column(
                                              children: <Widget>[
                                                Text("Login",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text('Login to your account',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 15,
                                                    )
                                                ),
                                              ]
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Column(
                                              children: <Widget>[
                                                inputFile(
                                                    label: "Email/Username",
                                                    controller: EmailController),
                                                inputFile(label: "Password",
                                                    obscureText: true,
                                                    controller: PasswordController),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40),
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 30, left: 3),
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
                                                    onPressed: () async {
                                                      String role= '';
                                                      String user = '';
                                                      int id = 0;
                                                      int succ = 0;
                                                      for (int i = 0; i <
                                                          Patients.data!
                                                              .length; i++) {
                                                        //print(Patients.data![i].caretaker_id);
                                                        // print(EmailController.text);
                                                        // print(snapshot.data![i].email);
                                                        if (EmailController
                                                            .text ==
                                                            Patients.data![i]
                                                                .email ||
                                                            EmailController
                                                                .text ==
                                                                Patients
                                                                    .data![i]
                                                                    .username) {
                                                          //print('same email');
                                                          if (PasswordController
                                                              .text ==
                                                              Patients.data![i]
                                                                  .password) {
                                                            succ = 1;
                                                            role= 'patient';
                                                            user = Patients
                                                                .data![i]
                                                                .username;
                                                            id = Patients
                                                                .data![i]
                                                                .patient_id;
                                                          }
                                                        }
                                                      }
                                                      for (int i = 0; i <
                                                          Caretaker.data!
                                                              .length; i++) {
                                                        //print(Patients.data![i].caretaker_id);
                                                        // print(EmailController.text);
                                                        // print(snapshot.data![i].email);
                                                        if (EmailController
                                                            .text ==
                                                            Caretaker.data![i]
                                                                .email ||
                                                            EmailController
                                                                .text ==
                                                                Caretaker
                                                                    .data![i]
                                                                    .username) {
                                                          //print('same email');
                                                          if (PasswordController
                                                              .text ==
                                                              Caretaker.data![i]
                                                                  .password) {
                                                            succ = 1;
                                                            role= 'caretaker';
                                                            user = Caretaker
                                                                .data![i]
                                                                .username;
                                                            id = Caretaker
                                                                .data![i]
                                                                .caretaker_id;
                                                          }
                                                        }
                                                      }
                                                      if (succ == 1) {
                                                        SharedPreferences preferences = await SharedPreferences
                                                            .getInstance();
                                                        preferences.setString(
                                                            'user',
                                                            user);
                                                        preferences.setString(
                                                            'role',
                                                            role);
                                                        preferences.setInt(
                                                            'id',
                                                            id);
                                                      }
                                                      showAlertDialog(
                                                          context, succ, role, user,
                                                          id);
                                                    },
                                                    color: Colors.blue,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(50),

                                                    ),
                                                    child: Text("Login",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                              )
                                          ),

                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text('Dont have an account? ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text('Sign up',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 15,
                                                    ))
                                              ]
                                          ),
                                          // Container(
                                          //     padding: EdgeInsets.only(top:100),
                                          //     height: 200,
                                          //     decoration: BoxDecoration(
                                          //         image: DecorationImage(
                                          //             image: AssetImage('assets/Heart.svg.png')
                                          //         )
                                          //     )
                                          // )
                                        ]
                                    ))
                                  ],
                                )
                            );
                          }
                        }
                      );
                })
        )));
  }
}

showAlertDialog(BuildContext context, int success, String role, String user, int id) {
  // Create button
  Widget successButton = RaisedButton(
    child: Text("OK"),
    onPressed: () async{
      var bluestt= await Permission.bluetooth.status;
      var loc= await Permission.location.status;
      var phone= await Permission.phone.status;
      if(user!=null && user != '') {
        if(bluestt.isGranted && loc.isGranted && phone.isGranted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MainPage(username: user, role: role, id: id, succ: 1);
              },
            ),
          );
        }
        else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return reqloc(username: user, role: role, id: id, succ: 1);
              },
            ),
          );
        }
      }
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
    title: Text("Login Successful!"),
    content: Text("Welcome!"),
    actions: [
      successButton,
    ],
  );

  AlertDialog alertFailed = AlertDialog(
    title: Text("Login failed!"),
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

Widget inputFile({label, obscureText= false, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          )
        ),
      ),
      SizedBox(height: 10)
    ]
  );
}