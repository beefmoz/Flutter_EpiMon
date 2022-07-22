import 'dart:async';
// import 'dart:isolate';
// import 'dart:convert';
import 'package:epimon2/Login.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as ble;
import 'package:epimon2/EpilepsyHistoryList.dart';
import 'package:epimon2/InfoPage.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:flutter_tts/flutter_tts.dart';
import './SelectBondedDevicePage.dart';

import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;


import 'package:epimon2/api_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainPageConnected_2.dart';
import 'NavBar.dart';

// import './helpers/LineChart.dart';
Future<void> init() async {
  await initializeService();
}

Future<void> initializeService() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  String hr = '';
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      // print('setforeground');
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (event["hr"] != null) {
      hr = event["hr"];
    }
  }

  );

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    if(hr!='') {
      service.setNotificationInfo(
        title: "EpiMon",
        content: "Heart Rate: " + hr + ' bpm',
      );
    }
    else {
      service.setNotificationInfo(
        title: "EpiMon",
        content: 'Awaiting connection with device...',
      );
    }
  });
}

class MainPage extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  final int conn;
  final ble.BluetoothDevice? device;
  const MainPage({required this.username, required this.role, required this.id, required this.succ, required this.conn, required this.device});
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  var location= new loc.Location();
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    init();
    super.initState();
    // Get current state
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.succ==1) {
    //   showAlertDialog(context);
    // }
    if (widget.conn==1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return MainPageConnected2(username: widget.username, role: widget.role, id: widget.id, device: widget.device!);
        // return DeviceScreen(device: r.device);
      }));
    }
    // print('mainpage');
    // print('setforeground');
    FlutterBackgroundService()
        .sendData({"action": "setAsBackground"});
    final Telephony telephony = Telephony.instance;
    final FlutterTts fluttertts = FlutterTts();
    int epi=1;
    String? currloc;
    Future<CallState> callstate= telephony.callState;
    // speak();

    return WillPopScope(
    onWillPop: () async {
      FlutterForegroundTask.minimizeApp();
      // Navigator.pop(context, true);
      // showLogoutDialog(context);
      return false;
    },
        child: Scaffold(
        drawer: NavBar(username: widget.username, role: widget.role, id: widget.id, location:currloc.toString(), device: null),
        appBar: AppBar(
          title: const Text('EpiMon'),
          // leading: GestureDetector(
          //   onTap: () { /* Write listener code here */ },
          //   child: Icon(
          //     Icons.menu,  // add custom icons also
          //   ),
          // ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showLogoutDialog(context);
                  },
                  child: Icon(
                    Icons.logout,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: Container(
            child: FutureBuilder<List<geo.Placemark>>(
                future: checkloc(),
                builder: (context, l) {
                  return FutureBuilder<List<PatientInfo>>(
                      future: API_Manager().getPatientsList(),
                      builder: (context, p) {
                        return FutureBuilder<List<CaretakerInfo>>(
                            future: API_Manager().getCaretakersList(),
                            builder: (context, c) {
                              return FutureBuilder<CallState>(
                                  future: callstate,
                                  builder: (context, cs) {
                                    String name = '';
                                    String crtk = '';
                                    String crtkcon = '';
                                    int? crtkint = 0;
                                    String cont= '';


                                    if (l.data == null || p.data == null ||
                                        c.data == null || cs.data == null) {
                                      // print(l.error?.toString());
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    //
                                    // print(cs.data);

                                    for (int x = 0; x < p.data!.length; x++) {
                                      if (widget.username == p.data![x].username) {
                                        name = p.data![x].name;
                                        crtkint = p.data![x].caretaker_id;
                                        cont = p.data![x].contact;
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
                                    currloc = l.data![0].street;

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
                                          ListTile(
                                            title: ElevatedButton(
                                              child: const Text(
                                                  'Pair with Epilepsy Detector'),
                                              onPressed: () async {
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return FlutterBlueApp(username: widget.username,
                                                            role: widget.role,
                                                            id: widget.id,
                                                            succ: widget.succ);
                                                      },
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),

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
                                                    // print(
                                                    //     Caretaker.error?.toString());
                                                    // print(p.error?.toString());
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
        )));

  }

  showLogoutDialog(BuildContext context) {
    // Create button
    Widget YesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () async{
        SharedPreferences preferences= await SharedPreferences.getInstance();
        preferences.setString('user', '');
        preferences.setString('role', '');
        preferences.setInt('id', 0);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      },
    );
    Widget NoButton = RaisedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertLogout = AlertDialog(
      title: Text("Logout"),
      content: Text("Do you wish to logout?"),
      actions: [
        YesButton, NoButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertLogout;
      },
    );
  }


  checkBluetooth() async {
    var bluestt= await Permission.bluetooth.status;
    var blueconn= await Permission.bluetoothConnect.status;
    var bluesc= await Permission.bluetoothScan.status;

    // print(bluestt);
    // print(blueconn);
    // print(bluesc);

    if (!bluestt.isGranted) {
      await Permission.bluetooth.request();
    }
    if (!blueconn.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    if (!bluesc.isGranted) {
      await Permission.bluetoothScan.request();
    }

    if(bluestt.isGranted && blueconn.isGranted && bluesc.isGranted) {
      // print('bluetooth perms granted');
      return;
    }
  }

  Future<List<geo.Placemark>> checkloc() async {
    var currcoord= await location.getLocation();
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(currcoord.latitude!.toDouble(), currcoord.longitude!.toDouble());
    // print(placemarks![0].street);
    return placemarks;
  }

}

