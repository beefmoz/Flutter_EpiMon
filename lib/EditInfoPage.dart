import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:epimon2/Login.dart';

import 'MainPage.dart';
import 'Models/Doctors_Class.dart';

class EditInfoPage extends StatefulWidget {
  @override
  final String name;
  final String username;
  final String email;
  final String age;
  final String contact;
  final String pw;
  final int id;
  final int succ;
  final String role;
  const EditInfoPage({required this.name, required this.username, required this.email, required this.age, required this.contact, required this.role, required this.pw, required this.id, required this.succ});
  _EditInfoPage createState() => new _EditInfoPage();
}

class _EditInfoPage extends State<EditInfoPage> {
  // final CaretakerController = TextEditingController();
  // final FNameController = TextEditingController();
  // final UNameController = TextEditingController();
  // final EmailController = TextEditingController();
  // final ContactController = TextEditingController();
  // final AgeController = TextEditingController();
  // final PasswordController = TextEditingController();
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

  getpreferences() async {
    SharedPreferences preferences = await SharedPreferences
        .getInstance();
    // var user= preferences.getString('user');
    // var role= preferences.getString('role');
    // var id= preferences.getInt('id');
    //
    // print(user);
    // print(role);
    // print(id);

    preferences.setString(
        'user',
        '');
    preferences.setString(
        'role',
        '');
  }

  @override
  void initState() {
    super.initState();
    getpreferences();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final FNameController = TextEditingController(text: widget.name);
    final UNameController = TextEditingController(text: widget.username);
    final EmailController = TextEditingController(text: widget.email);
    final ContactController = TextEditingController(text: widget.contact);
    final AgeController = TextEditingController(text: widget.age.toString());
    final PasswordController = TextEditingController(text: widget.pw);

    // final FNameController = TextEditingController();
    // final UNameController = TextEditingController();
    // final EmailController = TextEditingController();
    // final ContactController = TextEditingController();
    // final AgeController = TextEditingController();
    // final PasswordController = TextEditingController();
    if(widget.role=='patient') {
      return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            SharedPreferences preferences = await SharedPreferences
                .getInstance();
            // var user= preferences.getString('user');
            // var role= preferences.getString('role');
            // var id= preferences.getInt('id');
            preferences.setString(
                'user',
                widget.username);
            preferences.setString(
                'role',
                widget.role);
            preferences.setInt(
                'id',
                widget.id!);
            return false;
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                brightness: Brightness.light,
                title: const Text('EpiMon'),
              ),
              body: SingleChildScrollView(
                  child: FutureBuilder<List<DoctorInfo>>(
                      future: API_Manager().getDoctorsList(),
                      builder: (context, snapshot) {
                        return FutureBuilder<List<CaretakerInfo>>(
                            future: API_Manager().getCaretakersList(),
                            builder: (context, snapshot2) {
                              return FutureBuilder<List<PatientInfo>>(
                                  future: API_Manager().getPatientsList(),
                                  builder: (context, snapshot3) {
                                    doctors.clear();
                                    caretakers.clear();
                                    String dropdownvalue = 'docA';
                                    if (snapshot.data == null ||
                                        snapshot2.data ==
                                            null || snapshot3.data == null) {
                                      // print('error: ');
                                      // print(snapshot.error?.toString());
                                      // print(snapshot2.error?.toString());
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 40),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    else {
                                      String name = '';
                                      String username = '';
                                      String email = '';
                                      int age = 0;
                                      String contact = '';
                                      String pw = '';
                                      int patientid = 0;
                                      int doctorid = 0;
                                      int? caretakerid = 0;

                                      String doctorusername = '';
                                      String doctoremail = '';

                                      String caretakername = '';


                                      for (int i = 0; i <
                                          snapshot3.data!.length; i++) {
                                        if (widget.username ==
                                            snapshot3.data![i].username) {
                                          name = snapshot3.data![i].name;
                                          username =
                                              snapshot3.data![i].username;
                                          email = snapshot3.data![i].email;
                                          age = snapshot3.data![i].age;
                                          contact = snapshot3.data![i].contact;
                                          patientid =
                                              snapshot3.data![i].patient_id;
                                          caretakerid =
                                              snapshot3.data![i].caretaker_id;
                                          doctorid =
                                              snapshot3.data![i].doctor_id;
                                          pw = snapshot3.data![i].password;
                                        }
                                      }
                                      for (int x = 0; x <
                                          snapshot.data!.length; x++) {
                                        if (doctorid ==
                                            snapshot.data![x].user_id) {
                                          doctorusername =
                                              snapshot.data![x].username;
                                          doctoremail = snapshot.data![x].email;
                                        }
                                      }
                                      for (int x = 0; x <
                                          snapshot2.data!.length; x++) {
                                        if (caretakerid ==
                                            snapshot2.data![x].caretaker_id) {
                                          caretakername =
                                              snapshot2.data![x].name;
                                        }
                                      }
                                      // caretaker= CaretakerController.text;
                                      // for (var c in snapshot2.data!) {
                                      //   caretakers.add(c.name.toString());
                                      //   if (caretaker == c.name.toString()) {
                                      //     careid = c.caretaker_id;
                                      //   }
                                      //   // print('caretaker: ');
                                      //   // print(careid);
                                      // }
                                      // print(name);
                                      // print(username);
                                      // print(email);
                                      // print(contact);
                                      // print(widget.role);

                                      return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height + 150,
                                          width: double.infinity,
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Text('Edit Info',
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                        )
                                                    ),
                                                    SizedBox(height: 15),
                                                    Text('Edit your info',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey[700],
                                                          fontSize: 15,
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                    children: <Widget>[
                                                      inputFile(
                                                        label: "Full name",
                                                        controller: FNameController,
                                                      ),

                                                      inputFile(
                                                        label: "Preferred Username",
                                                        controller: UNameController,
                                                      ),

                                                      inputFile(
                                                        label: "Email",
                                                        controller: EmailController,
                                                      ),

                                                      inputFile(
                                                        label: "Contact",
                                                        controller: ContactController,
                                                      ),

                                                      inputFile(label: "Age",
                                                        controller: AgeController,
                                                      ),

                                                      inputFile(
                                                        label: "Password",
                                                        controller: PasswordController,
                                                      ),
                                                    ]
                                                ),
                                                ListTile(
                                                  title: ElevatedButton(
                                                      child: const Text(
                                                          'Confirm edit'),
                                                      onPressed: () async {
                                                        String fname = FNameController.text;
                                                        String uname = UNameController.text;
                                                        String email = EmailController.text;
                                                        String contact = ContactController.text;
                                                        String age = AgeController.text;
                                                        String pw = PasswordController.text;

                                                        Map<String, dynamic> jsonMp2 = {
                                                          "name": '"' + fname + '"',
                                                          "username": '"' + uname + '"',
                                                          "email": '"' + email + '"',
                                                          "contact": '"' + contact + '"',
                                                          "age": age,
                                                          "password": '"' + pw + '"',
                                                          "patient_id": '"' + patientid.toString() + '"',
                                                        };

                                                        String jsonString = json.encode(jsonMp2);

                                                        try {
                                                          var response = await http.post(
                                                              Uri.parse(
                                                                  'http://aspepilepsyproject.atspace.cc/access/updatepatientinfo.php'),
                                                              body: jsonString
                                                          );
                                                          // print(response.body);
                                                          // print(response.statusCode);
                                                        } catch (e) {
                                                          // print("Error");
                                                          // print(e);
                                                        }
                                                        showAlertDialog(context, success, widget.role, widget.username, widget.id);
                                                      }
                                                  ),
                                                ),
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

          )
      );
    }

    else {
      return WillPopScope(
          onWillPop: () async {
        Navigator.of(context).pop();
        SharedPreferences preferences = await SharedPreferences
            .getInstance();
        // var user= preferences.getString('user');
        // var role= preferences.getString('role');
        // var id= preferences.getInt('id');
        preferences.setString(
            'user',
            widget.username);
        preferences.setString(
            'role',
            widget.role);
        preferences.setInt(
            'id',
            widget.id!);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Edit Info")
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
                    String pw='';

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
                          pw = Caretaker.data![i].password;
                        }
                      }
                      for (int x = 0; x < Patient.data!.length; x++) {
                        if (patientid == Patient.data![x].patient_id) {
                          Patientname = Patient.data![x].name;
                          Patientemail = Patient.data![x].email;
                        }
                      }
                      final FNameController = TextEditingController(text: name);
                      final UNameController = TextEditingController(text: username);
                      final EmailController = TextEditingController(text: email);
                      final ContactController = TextEditingController(text: contact);
                      final PasswordController = TextEditingController(text: pw);
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
                                        inputFile(label: "Full name",
                                            controller: FNameController),

                                        inputFile(label: "Preferred Username",
                                            controller: UNameController),

                                        inputFile(
                                            label: "Email",
                                            controller: EmailController),

                                        inputFile(label: "Contact",
                                            controller: ContactController),

                                        inputFile(label: "Password",
                                            controller: PasswordController,
                                        ),

                                        ListTile(
                                          title: ElevatedButton(
                                              child: const Text(
                                                  'Confirm edit'),
                                              onPressed: () async {
                                                String fname = FNameController.text;
                                                String uname = UNameController.text;
                                                String email = EmailController.text;
                                                String contact = ContactController.text;
                                                String pw = PasswordController.text;

                                                Map<String, dynamic> jsonMp2 = {
                                                  "name": '"' + fname + '"',
                                                  "username": '"' + uname + '"',
                                                  "email": '"' + email + '"',
                                                  "contact": '"' + contact + '"',
                                                  "password": '"' + pw + '"',
                                                  "caretaker_id": '"' + caretakerid.toString() + '"',
                                                };

                                                String jsonString = json.encode(jsonMp2);

                                                try {
                                                  var response = await http.post(
                                                      Uri.parse(
                                                          'http://aspepilepsyproject.atspace.cc/access/updatecaretakerinfo.php'),
                                                      body: jsonString
                                                  );
                                                  // print(response.body);
                                                  // print(response.statusCode);
                                                } catch (e) {
                                                  // print("Error");
                                                  // print(e);
                                                }
                                                showAlertDialog(context, success, widget.role, widget.username, widget.id);
                                              }
                                          ),
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
      )
      );
    }
  }
  showAlertDialog(BuildContext context, int success, String role, String user, int id) {
    // Create button
    Widget successButton = RaisedButton(
      child: Text("OK"),
      onPressed: () async{
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainPage(username: user, role: role, id: id, succ: 1, conn:0, device: null,);
            },
          ),
        );
      },
    );

    // Create AlertDialog
    AlertDialog alertSuccess = AlertDialog(
      title: Text("Edit Successful!"),
      content: Text("Your details have been successfully edited!"),
      actions: [
        successButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertSuccess;
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
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 10)
      ]
  );
}