import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:epimon2/Models/EpilepsyHistory_Class.dart';
import 'package:http/http.dart' as http;
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:epimon2/api_manager.dart';
import 'package:intl/intl.dart';

class ChartData {
  ChartData(this.s, this.hr);
  final int s;
  final double hr;
}

class HistoryPage extends StatefulWidget {
  final int id;
  final String name;
  const HistoryPage({required this.id, required this.name});
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //late List<History> epilepsyHistory;
  @override
  void initState() {
    //epilepsyHistory=
    super.initState();
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
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.name +"'s History")
        ),
        body: Container(
          child: Card(
            child: FutureBuilder<List<History>>(
                future: API_Manager().getHistoryData(),
                builder: (context, snapshot){
                  return FutureBuilder<List<PatientInfo>>(
                      future: API_Manager().getPatientsList(),
                      builder: (context, patient){
                        if(snapshot.data==null || patient.data==null ) {
                          // print('error: ');
                          // print(snapshot.error?.toString());
                          return Container(child: Center(child: CircularProgressIndicator(),
                          ),
                          );
                        }
                        else {
                          List<History> currentPatientHistory= [];
                          // for (int i=0; i<snapshot.data!.length; i++){
                          //   if(widget.id==snapshot.data![i].patient_id) {
                          //     currentPatientHistory.add(snapshot.data![i]);
                          //   }
                          // }
                          for (int i=snapshot.data!.length-1; i>=0; i--){
                            if(widget.id==snapshot.data![i].patient_id) {
                              currentPatientHistory.add(snapshot.data![i]);
                              if(currentPatientHistory.length==5) {
                                break;
                              }
                            }
                          }

                          return SafeArea(child: ListView.builder(
                            itemCount: currentPatientHistory.length,
                            itemBuilder: (context, i) {
                              List<String> hrstringlist= currentPatientHistory[i].heartrate_history.replaceAll('[', '').replaceAll(']', '').split(',');
                              final List<ChartData> hrlist= [];
                              for (int t=0; t<hrstringlist.length; t++) {
                                if(hrstringlist[t]=="") {
                                  hrstringlist.remove(hrstringlist[t]);
                                }
                                else {
                                  // print(hrstringlist[t]);
                                  double hr = double.parse(hrstringlist[t]);
                                  hrlist.add(ChartData(t * 10, hr));
                                }
                              }
                              //print(hrlist[i].hr);
                              return Card(
                                child: ExpansionTile(
                                  title: Text(parseDateTimeDisplay(DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(currentPatientHistory[i].timestart)))),
                                  children: [Text("Average Heart Rate: " + currentPatientHistory[i].HeartRate.toString() + "bpm"),
                                    Text("Average Stress Level: " + currentPatientHistory[i].Stress.toString() ),
                                    SizedBox(height: 20),
                                    SfCartesianChart(
                                      title: ChartTitle(text: 'Heart Rate Readings'),
                                      primaryXAxis:CategoryAxis(
                                          labelRotation: 0
                                      ),
                                      series: <ChartSeries>[
                                        LineSeries<ChartData, int>(dataSource: hrlist, xValueMapper: (ChartData datas, _)=>datas.s, yValueMapper: (ChartData datas, _)=> datas.hr)
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
        ));
  }
}
