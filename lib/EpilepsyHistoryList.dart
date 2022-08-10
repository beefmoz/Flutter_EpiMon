import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:epimon2/Models/EpilepsyHistory_Class.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/api_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ChartData {
  ChartData(this.s, this.hr);
  final int s;
  final double hr;
}

class ChartData2 {
  ChartData2(this.s, this.str);
  final int s;
  final double str;
}

class HistoryPage extends StatefulWidget {
  final int id;
  final String name;
  final String? caretakername;
  final int? caretakerid;
  final String role;
  const HistoryPage({required this.id, required this.name, required this.caretakername, required this.caretakerid ,required this.role});
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //late List<History> epilepsyHistory;

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
    //epilepsyHistory=
    super.initState();
    getpreferences();

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    // NotesController.dispose();
    super.dispose();
  }

  String parseDateTimeDisplay(String datetime) {
    String month='';
    List<String> datetimecontents= datetime.split('-');
    List<String> datewithtime= datetimecontents[2].split(' – ');
    // print(datetimecontents); //[2022, 05, 23 - 09:15]
    switch(datetimecontents[1]) {
      case '01': {
        month= 'January';
      }
      break;
      case '02': {
        month= 'February';
      }
      break;
      case '03': {
        month= 'March';
      }
      break;
      case '04': {
        month= 'April';
      }
      break;
      case '05': {
        month= 'May';
      }
      break;
      case '06': {
        month= 'June';
      }
      break;
      case '07': {
        month= 'July';
      }
      break;
      case '08': {
        month= 'August';
      }
      break;
      case '09': {
        month= 'September';
      }
      break;
      case '10': {
        month= 'October';
      }
      break;
      case '11': {
        month= 'November';
      }
      break;
      case '12': {
        month= 'December';
      }
      break;
    }
    // datetimecontents[2].split(' – ');
    // print(month);
    String datetimedisplay= datewithtime[0] + ' ' + month + ' ' + datetimecontents[0] + ' – ' + datewithtime[1];
    // print(datewithtime);
    // print(datetimedisplay);
    return datetimedisplay;
  }

  Widget build(BuildContext context) {
    if (widget.role=='patient') {
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
              widget.name);
          preferences.setString(
              'role',
              widget.role);
          preferences.setInt(
              'id',
              widget.id);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(widget.name + "'s History")
            ),
            body: Container(
              child: Card(
                child: FutureBuilder<List<History>>(
                    future: API_Manager().getHistoryData(),
                    builder: (context, snapshot) {
                      return FutureBuilder<List<PatientInfo>>(
                          future: API_Manager().getPatientsList(),
                          builder: (context, patient) {
                            if (snapshot.data == null || patient.data == null) {
                              // print('error: ');
                              // print(snapshot.error?.toString());
                              return Container(child: Center(
                                child: CircularProgressIndicator(),
                              ),
                              );
                            }
                            else {
                              List<History> currentPatientHistory = [];
                              for (int i = snapshot.data!.length - 1; i >=
                                  0; i--) {
                                if (widget.id == snapshot.data![i].patient_id) {
                                  currentPatientHistory.add(snapshot.data![i]);
                                  if (currentPatientHistory.length == 5) {
                                    break;
                                  }
                                }
                              }

                              return SafeArea(child: ListView.builder(
                                itemCount: currentPatientHistory.length,
                                itemBuilder: (context, i) {
                                  List<
                                      String> hrstringlist = currentPatientHistory[i]
                                      .heartrate_history.replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',');
                                  List<
                                      String> strstringlist = currentPatientHistory[i]
                                      .stress_history.replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',');
                                  final List<ChartData> hrlist = [];
                                  final List<ChartData2> strlist = [];
                                  final NotesController = TextEditingController(
                                      text: currentPatientHistory[i].notes);
                                  int historyid = currentPatientHistory[i].id;
                                  for (int t = 0; t <
                                      hrstringlist.length; t++) {
                                    if (hrstringlist[t] == "") {
                                      hrstringlist.remove(hrstringlist[t]);
                                    }
                                    else {
                                      // print(hrstringlist[t]);
                                      double hr = double.parse(hrstringlist[t]);
                                      hrlist.add(ChartData(t * 10, hr));
                                    }
                                  }

                                  for (int t = 0; t <
                                      strstringlist.length; t++) {
                                    if (strstringlist[t] == "") {
                                      strstringlist.remove(hrstringlist[t]);
                                    }
                                    if (strstringlist[t] == "") {
                                      strstringlist.remove(strstringlist[t]);
                                    }
                                    else {
                                      // print(hrstringlist[t]);
                                      double str = double.parse(
                                          strstringlist[t]);
                                      strlist.add(ChartData2(t * 10, str));
                                    }
                                  }
                                  //print(hrlist[i].hr);
                                  return Card(
                                    child: ExpansionTile(
                                      title: Text(parseDateTimeDisplay(
                                          DateFormat('yyyy-MM-dd – kk:mm')
                                              .format(DateTime.parse(
                                              currentPatientHistory[i]
                                                  .timestart)))),
                                      children: [
                                        Text("Average Heart Rate: " +
                                            currentPatientHistory[i].HeartRate
                                                .toString() + "bpm",
                                          style: TextStyle(
                                              color: Colors.indigo),),

                                        Text("Average Stress Level: " +
                                            currentPatientHistory[i].Stress
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.pink)),
                                        notesFile(label: 'Notes',
                                            controller: NotesController),
                                        RaisedButton(
                                            child: Text('Save note'),
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              String notes = NotesController
                                                  .text;
                                              Map<String, dynamic> jsonMp2 = {
                                                "notes": '"' + notes + '"',
                                                "id": '"' +
                                                    historyid.toString() + '"',
                                              };

                                              String jsonString = json.encode(
                                                  jsonMp2);

                                              try {
                                                var response = await http.post(
                                                    Uri.parse(
                                                        'http://aspepilepsyproject.atspace.cc/access/updatehistorynotes.php'),
                                                    body: jsonString
                                                );
                                                print(response.body);
                                                print(response.statusCode);
                                              } catch (e) {
                                                // print("Error");
                                                // print(e);
                                              }
                                              showAlertDialog(context);
                                            }
                                        ),
                                        SizedBox(height: 20),
                                        SfCartesianChart(
                                          title: ChartTitle(
                                              text: 'Heart Rate and Stress readings'),
                                          primaryXAxis: CategoryAxis(
                                              labelRotation: 0
                                          ),
                                          series: <ChartSeries>[
                                            LineSeries<ChartData, int>(
                                                dataSource: hrlist,
                                                xValueMapper: (ChartData datas,
                                                    _) => datas.s,
                                                yValueMapper: (ChartData datas,
                                                    _) => datas.hr),
                                            LineSeries<ChartData2, int>(
                                                dataSource: strlist,
                                                xValueMapper: (ChartData2 datas,
                                                    _) => datas.s,
                                                yValueMapper: (ChartData2 datas,
                                                    _) => datas.str),
                                          ],),
                                      ],
                                    ),
                                  );
                                },
                              )
                              );
                              //return SafeArea(child: Scaffold( body: SfCartesianChart()));
                            }
                          }
                      );
                    }),
              ),
            )),
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
              widget.caretakername!);
          preferences.setString(
              'role',
              widget.role);
          preferences.setInt(
              'id',
              widget.caretakerid!);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(widget.name + "'s History")
            ),
            body: Container(
              child: Card(
                child: FutureBuilder<List<History>>(
                    future: API_Manager().getHistoryData(),
                    builder: (context, snapshot) {
                      return FutureBuilder<List<PatientInfo>>(
                          future: API_Manager().getPatientsList(),
                          builder: (context, patient) {
                            if (snapshot.data == null || patient.data == null) {
                              // print('error: ');
                              // print(snapshot.error?.toString());
                              return Container(child: Center(
                                child: CircularProgressIndicator(),
                              ),
                              );
                            }
                            else {
                              List<History> currentPatientHistory = [];
                              for (int i = snapshot.data!.length - 1; i >=
                                  0; i--) {
                                if (widget.id == snapshot.data![i].patient_id) {
                                  currentPatientHistory.add(snapshot.data![i]);
                                  if (currentPatientHistory.length == 5) {
                                    break;
                                  }
                                }
                              }

                              return SafeArea(child: ListView.builder(
                                itemCount: currentPatientHistory.length,
                                itemBuilder: (context, i) {
                                  List<
                                      String> hrstringlist = currentPatientHistory[i]
                                      .heartrate_history.replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',');
                                  List<
                                      String> strstringlist = currentPatientHistory[i]
                                      .stress_history.replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',');
                                  final List<ChartData> hrlist = [];
                                  final List<ChartData2> strlist = [];
                                  for (int t = 0; t <
                                      hrstringlist.length; t++) {
                                    if (hrstringlist[t] == "") {
                                      hrstringlist.remove(hrstringlist[t]);
                                    }
                                    else {
                                      // print(hrstringlist[t]);
                                      double hr = double.parse(hrstringlist[t]);
                                      hrlist.add(ChartData(t * 10, hr));
                                    }
                                  }

                                  for (int t = 0; t <
                                      strstringlist.length; t++) {
                                    if (strstringlist[t] == "") {
                                      strstringlist.remove(hrstringlist[t]);
                                    }
                                    if (strstringlist[t] == "") {
                                      strstringlist.remove(strstringlist[t]);
                                    }
                                    else {
                                      // print(hrstringlist[t]);
                                      double str = double.parse(
                                          strstringlist[t]);
                                      strlist.add(ChartData2(t * 10, str));
                                    }
                                  }
                                  //print(hrlist[i].hr);
                                  return Card(
                                    child: ExpansionTile(
                                      title: Text(parseDateTimeDisplay(
                                          DateFormat('yyyy-MM-dd – kk:mm')
                                              .format(DateTime.parse(
                                              currentPatientHistory[i]
                                                  .timestart)))),
                                      children: [
                                        Text("Average Heart Rate: " +
                                            currentPatientHistory[i].HeartRate
                                                .toString() + "bpm",
                                          style: TextStyle(
                                              color: Colors.indigo),),

                                        Text("Average Stress Level: " +
                                            currentPatientHistory[i].Stress
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.pink)),
                                        ListTile(
                                          title: const Text("Notes",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              )),
                                          subtitle: Text(currentPatientHistory[i].notes),
                                        ),
                                        SizedBox(height: 20),
                                        SfCartesianChart(
                                          title: ChartTitle(
                                              text: 'Heart Rate and Stress readings'),
                                          primaryXAxis: CategoryAxis(
                                              labelRotation: 0
                                          ),
                                          series: <ChartSeries>[
                                            LineSeries<ChartData, int>(
                                                dataSource: hrlist,
                                                xValueMapper: (ChartData datas,
                                                    _) => datas.s,
                                                yValueMapper: (ChartData datas,
                                                    _) => datas.hr),
                                            LineSeries<ChartData2, int>(
                                                dataSource: strlist,
                                                xValueMapper: (ChartData2 datas,
                                                    _) => datas.s,
                                                yValueMapper: (ChartData2 datas,
                                                    _) => datas.str),
                                          ],),
                                      ],
                                    ),
                                  );
                                },
                              )
                              );
                              //return SafeArea(child: Scaffold( body: SfCartesianChart()));
                            }
                          }
                      );
                    }),
              ),
            )),
      );
    }
  }
  showAlertDialog(BuildContext context) {
    // Create button
    Widget successButton = RaisedButton(
      child: Text("OK"),
      onPressed: () async{
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertSuccess = AlertDialog(
      title: Text("Note added!"),
      content: Text("Your notes have been saved."),
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

Widget notesFile({label, obscureText= false, controller})
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