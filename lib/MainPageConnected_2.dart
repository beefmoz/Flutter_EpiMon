import 'dart:async';

import 'package:epimon2/Models/Caretaker_Class.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as ble;
import 'package:scoped_model/scoped_model.dart';
import 'package:epimon2/EpilepsyHistoryList.dart';
import 'package:epimon2/InfoPage.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:epimon2/BackgroundCollectingTask.dart';

import './Warning2.dart';
import 'package:epimon2/Calling.dart';

import './SelectBondedDevicePage.dart';
import 'package:http/http.dart' as http;
//import 'package:url_launcher/url_launcher.dart';
//

import 'package:telephony/telephony.dart';
import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:flutter_tts/flutter_tts.dart';

// import './helpers/LineChart.dart';

class MainPageConnected2 extends StatefulWidget {
  final ble.BluetoothDevice device;
  final String username;
  final String role;
  final int id;
  const MainPageConnected2({required this.device, required this.username, required this.role, required this.id});
  @override
  _MainPageConnected2 createState() => new _MainPageConnected2();
}

class _MainPageConnected2 extends State<MainPageConnected2> {
  var location= new loc.Location();
  final Telephony telephony = Telephony.instance;
  final FlutterTts fluttertts= FlutterTts();
  String? loct='';
  String hrstring= "...  ";
  int hr=0;
  int loadingblue=1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // ser.FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    // _collectingTask?.dispose();
    super.dispose();
  }


  @override

  Widget build(BuildContext context) {
    print('hello0');
    // widget.device.connect();
    // widget.device.discoverServices();

    return Scaffold(
        appBar: AppBar(
          title: const Text('EpiMon'),
        ),
        body: Container(
            child: StreamBuilder<List<ble.BluetoothService>?>(
                stream: widget.device.services,
                builder: (context, snapshotblue) {
                  print('hello1');
                  return FutureBuilder<List<PatientInfo>>(
                      future: API_Manager().getPatientsList(),
                      builder: (context, p) {
                        print('hello2');
                        return FutureBuilder<List<CaretakerInfo>>(
                            future: API_Manager().getCaretakersList(),
                            builder: (context, c) {
                              print('hello3');
                              return FutureBuilder<List<geo.Placemark> >(
                                  future: checkloc(),
                                  builder: (s, l) {
                                    String name = '';
                                    String cont= '';
                                    String crtk = '';
                                    String crtkcon = '';
                                    int? crtkint = 0;

                                    print('hello4');

                                    // final receivePort = ReceivePort();
                                    //
                                    // Isolate.spawn(checklocbg!,receivePort.sendPort);
                                    //
                                    // receivePort.listen((loca) {
                                    //   print(loca!);
                                    // });

                                    // print(l);

                                    if (l.data == null || p.data == null ||
                                        c.data == null || snapshotblue.data == null) {
                                      // print(l.error?.toString());
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }


                                    for (int x = 0; x < p.data!.length; x++) {
                                      if (widget.username == p.data![x].username) {
                                        name = p.data![x].name;
                                        crtkint = p.data![x].caretaker_id;
                                        cont= p.data![x].contact;
                                        //print(name);
                                      }
                                    }
                                    for (int y = 0; y < c.data!.length; y++) {
                                      if (crtkint == c.data![y].caretaker_id) {
                                        crtk = c.data![y].name;
                                        crtkcon = c.data![y].contact;
                                        //print(crtk);
                                      }
                                    }
                                    var currloc = l.data![0].street;
                                    if (widget.role == 'patient') {
                                      return ListView(
                                        children: <Widget>[
                                          Divider(),
                                          ListTile(
                                              title: Text(
                                                  'Welcome, ' + widget.username + '!',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              )
                                          ),
                                          Divider(),
                                          ListTile(
                                              title:
                                              // Text('Current location: 13 Tampines Ave',
                                              Text('Current location: ' + currloc.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600
                                                  )
                                              )
                                          ),
                                          //   }
                                          // ),
                                          Divider(),
                                          Center(
                                            child: ListTile(
                                              title: Text(
                                                  'Before using this application, ensure your Epilepsy Detector is connected to check on your current health status!'),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ListTile(
                                              leading: Image.asset(
                                                'heart.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                              title: Text('Heart Rate: ... bpm')
                                          ),
                                          SizedBox(height: 12),
                                          ListTile(
                                              leading: Image.asset(
                                                'brain.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                              title: Text('Stress level: ...',)
                                          ),
                                          SizedBox(height: 12),
                                          ListTile(
                                              leading: Image.asset(
                                                'shoe.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                              title: Text('Steps taken: ... steps')
                                          ),
                                          SizedBox(height: 12),
                                          ListTile(
                                            title: ElevatedButton(
                                                child: const Text('View history'),
                                                onPressed: () async {
                                                  final ble
                                                      .BluetoothDevice? selectedDevice =
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return HistoryPage(
                                                          id: widget.id, name: name,);
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                          ListTile(
                                            title: ElevatedButton(
                                                child: const Text('View your info'),
                                                onPressed: () async {
                                                  final ble
                                                      .BluetoothDevice? selectedDevice =
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return InfoPage(
                                                            username: widget.username,
                                                            role: widget.role);
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                          // ListTile(
                                          //   title: ElevatedButton(
                                          //     child: const Text(
                                          //         'Pair with Epilepsy Detector'),
                                          //     onPressed: () async {
                                          //       var blueconn= await Permission.bluetoothConnect.status;
                                          //       if (!blueconn.isGranted) {
                                          //         await Permission.bluetoothConnect.request();
                                          //       }
                                          //       if(blueconn.isGranted) {
                                          //         print('bluetooth perms granted');
                                          //         await Navigator.of(context).push(
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return FlutterBlueApp(
                                          //                   username: widget.username,
                                          //                   id: widget.id,
                                          //                   role: widget.role,
                                          //                   succ: widget.succ);
                                          //             },
                                          //           ),
                                          //         );
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                          // ListTile(
                                          //   title: ElevatedButton(
                                          //       child: const Text('func'),
                                          //       onPressed: ()  {
                                          //         speak();
                                          //       }),
                                          // ),
                                          Divider(),

                                        ],
                                      );
                                    }
                                    else {
                                      return FutureBuilder<List<CaretakerInfo>>(
                                          future: API_Manager().getCaretakersList(),
                                          builder: (context, Caretaker) {
                                            return FutureBuilder<List<PatientInfo>>(
                                                future: API_Manager()
                                                    .getPatientsList(),
                                                builder: (context, p) {
                                                  String pname = '';
                                                  if (Caretaker.data == null ||
                                                      p.data == null) {
                                                    print(
                                                        Caretaker.error?.toString());
                                                    print(p.error?.toString());
                                                    return Container(
                                                      child: Center(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  }
                                                  int? patientid = 0;
                                                  for (int i = 0; i <
                                                      Caretaker.data!.length; i++) {
                                                    if (Caretaker.data![i]
                                                        .caretaker_id == widget.id) {
                                                      patientid = Caretaker.data![i]
                                                          .patient_id;
                                                    }
                                                  }
                                                  for (int i = 0; i <
                                                      p.data!.length; i++) {
                                                    if (p.data![i].patient_id ==
                                                        patientid) {
                                                      pname = p.data![i].name;
                                                    }
                                                  }
                                                  return ListView(
                                                      children: <Widget>[
                                                        Divider(),
                                                        ListTile(
                                                            title: Text('Welcome, ' +
                                                                widget.username + '!',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight
                                                                        .bold
                                                                )
                                                            )
                                                        ),
                                                        Divider(),
                                                        ListTile(
                                                            title: Text(
                                                                'Current location: ' +
                                                                    currloc
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .w600
                                                                )
                                                            )
                                                        ),
                                                        //   }
                                                        // ),
                                                        Divider(),
                                                        ListTile(
                                                          title: ElevatedButton(
                                                              child: const Text(
                                                                  'View your info'),
                                                              onPressed: () async {
                                                                final ble
                                                                    .BluetoothDevice? selectedDevice =
                                                                await Navigator.of(
                                                                    context).push(
                                                                  MaterialPageRoute(
                                                                    builder: (
                                                                        context) {
                                                                      return InfoPage(
                                                                          username: widget
                                                                              .username,
                                                                          role: widget
                                                                              .role);
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                        SizedBox(height: 12),
                                                        ListTile(
                                                          title: ElevatedButton(
                                                              child: const Text(
                                                                  "View Patient's Epileptic History"),
                                                              onPressed: () async {
                                                                final ble
                                                                    .BluetoothDevice? selectedDevice =
                                                                await Navigator.of(
                                                                    context).push(
                                                                  MaterialPageRoute(
                                                                    builder: (
                                                                        context) {
                                                                      return HistoryPage(
                                                                        id: patientid!,
                                                                        name: pname,);
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ]
                                                  );
                                                }
                                            );
                                          }
                                      );
                                    }
                                  });
                            }
                        );
                      });
                })
        ));
  }


  postData()async{ //post dt to server
    //final JSONObject dataJson = new JSONObject();
    Map<String, dynamic> jsonMp= {
      "Stress": int.parse(hrstring).toDouble().toString(),
      "AccelerometerX": "3.10",
      "AccelerometerY": "2.10",
      "AccelerometerZ": "4.10",
      "HeartRate": "100.50",
      "timestart": "'" + DateTime.now().toString()+ "'" ,
      "timestop": "'" + DateTime.now().toString()+ "'",
      "Gyroscopic_Changes": "0",
      "patient_id": widget.id.toString()
    };
    String jsonString = json.encode(jsonMp);
    try {
      var response = await http.post(
          Uri.parse('http://aspepilepsyproject.atspace.cc/access/addPlayHistory.php'),
          body: jsonString
      );
      print(response.body);
      print(response.statusCode);
    } catch(e) {
      print("Error");
      print(e);
    }
  }

  postData2()async{ //post dt to server
    //final JSONObject dataJson = new JSONObject();
    Map<String, dynamic> jsonMp= {
      "Temperature": "26.53",
      "AccelerometerX": "3",
      "AccelerometerY": "2",
      "AccelerometerZ": "4",
      "HeartRate": "100.50",
      "timestamp": DateTime.now().toString(),
      "patient_id": widget.id.toString()
    };
    String jsonString = json.encode(jsonMp);
    try {
      var response = await http.post(
        Uri.parse('http://aspepilepsyproject.atspace.cc/access/SQLQUERY.php'),
      );
      print(response.body);
      print(response.statusCode);
    } catch(e) {
      print("Error");
      print(e);
    }
  }

  refresh(ble.BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    // print('notifying');
    await c.read();
    // print (c.read().toString());
  }

  off(ble.BluetoothCharacteristic c) async {
    await c.setNotifyValue(false);
    // print('notifying');
    // print (c.read().toString());
  }

  Future<List<geo.Placemark>> checkloc() async {
    var currcoord= await location.getLocation();
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(currcoord.latitude!.toDouble(), currcoord.longitude!.toDouble());
    return placemarks;
  }

// Future<void> _startBackgroundTask(
//     BuildContext context,
//     BluetoothDevice server,
//     ) async {
//   try {
//     _collectingTask = await BackgroundCollectingTask.connect(server);
//     await _collectingTask!.start();
//   } catch (ex) {
//     _collectingTask?.cancel();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error occured while connecting'),
//           content: Text("${ex.toString()}"),
//           actions: <Widget>[
//             new TextButton(
//               child: new Text("Close"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
}