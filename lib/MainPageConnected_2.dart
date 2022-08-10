import 'dart:async';
import 'dart:isolate';

import 'package:epimon2/Models/Caretaker_Class.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as ble;
import 'package:epimon2/EpilepsyHistoryList.dart';
import 'package:epimon2/InfoPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './Warning2.dart';

import 'package:telephony/telephony.dart';
import 'package:epimon2/api_manager.dart';
import 'package:epimon2/Models/PatientInfo_Class.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'Login.dart';
import 'MainPage.dart';
import 'NavBar.dart';

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
  StreamSubscription? subscriptionfall;
  StreamSubscription? subscriptionhr;

  @override

  //if()
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override

  Widget build(BuildContext context) {
    showLogoutDialog(BuildContext context) {
      // Create button
      Widget YesButton = RaisedButton(
        child: Text("Yes"),
        onPressed: () async{
          await widget.device.disconnect();
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

    // print('at mainpageconnected');


    // widget.device.connect();
    widget.device.discoverServices();
    // print('for mpstrt');
    //

    String? currloc;
    String cont= '';
    String name = '';
    String crtk = '';
    String crtkcon = '';
    int? crtkint;

    return WillPopScope(
        onWillPop: () async {
          // FlutterForegroundTask.minimizeApp();
          // showLogoutDialog(context);
          showDisconnectDialog(context);
          return false;
        },
        child: Scaffold(
            drawer: NavBar(username: widget.username, role: widget.role, id: widget.id, location:currloc.toString(), device: widget.device),
            appBar: AppBar(
              title: const Text('EpiMon'),
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
                child: StreamBuilder<List<ble.BluetoothService>?>(
                    stream: widget.device.services,
                    builder: (context, snapshotblue) {
                      if (!snapshotblue.hasData || snapshotblue.data==null || snapshotblue.data!.length<2) {
                        if(snapshotblue.hasData && snapshotblue.data!=null) {
                          if (snapshotblue.data!.length < 2) {
                            // widget.device.discoverServices();
                          }
                        }
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if(snapshotblue.hasData && snapshotblue.data!=null) {
                        if (snapshotblue.data!.length < 2 ) {
                          // widget.device.discoverServices();
                        }
                        // print('setforeground');
                        FlutterBackgroundService()
                            .sendData({"action": "setAsForeground"});

                        subscriptionfall =
                            snapshotblue.data![2].characteristics[0].value.listen((
                                event) {
                              if (event != null && event !=' ') {
                                String? fall;

                                // print('event:');
                                // print(ascii.decode(event));
                                fall = ascii.decode(event);
                                // print(fall);
                                if (fall == '1') {
                                  FlutterForegroundTask.launchApp();
                                  String emermsg = name +
                                      ' is currently having a stroke at ' +
                                      currloc.toString() +
                                      '. Please remain calm, ' +
                                      crtk +
                                      ", we will monitor the conditions and call for emergency immediately.";

                                  telephony.sendSms(
                                      to: crtkcon,
                                      message: emermsg
                                  );
                                  // print('sending message');

                                  snapshotblue.data![2].characteristics[0].write(utf8.encode('0'));
                                  // subscriptionfall!.pause();
                                  subscriptionfall!.cancel();

                                  // print(emermsg);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return WarningPage2(
                                            username: widget.username,
                                            name: name,
                                            role: widget.role,
                                            id: widget.id,
                                            server: widget
                                                .device,
                                            loc: currloc
                                                .toString(),
                                            crtkcon: crtkcon,
                                            cont: cont
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            });
                      }

                      subscriptionhr =
                          snapshotblue.data![2].characteristics[2].value.listen((event) {
                            int hr=0;
                            hrstring = ascii.decode(event).toString();
                            try{
                              hr= int.parse(hrstring);
                              // print(hr);
                              if (hrstring != null || hrstring!=' ') {
                                FlutterBackgroundService()
                                    .sendData({"hr": hrstring});
                              }
                            }catch (Exception) {
                              // print(Exception);
                            }
                          });

                      return FutureBuilder<List<PatientInfo>>(
                          future: API_Manager().getPatientsList(),
                          builder: (context, p) {

                            return FutureBuilder<List<CaretakerInfo>>(
                                future: API_Manager().getCaretakersList(),
                                builder: (context, c) {
                                  return FutureBuilder<List<geo.Placemark>>(
                                    future: checkloc(),
                                    builder: (context, snapshotloc) {


                                      // (!snapshotblue.data![2].characteristics[2].isNotifying || !snapshotblue.data![2].characteristics[3].isNotifying || !snapshotblue.data![2].characteristics[4].isNotifying)
                                      if (!snapshotloc.hasData || !c.hasData ||
                                          !p.hasData || !snapshotblue.hasData ||
                                          snapshotblue.data!.length < 2 ||
                                          snapshotblue.data == null) {
                                        //print(snapshot.error?.toString());
                                        return Container(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }

                                      else {
                                        // loct= snapshotloc.data![0].street;
                                        currloc = snapshotloc.data![0].street;
                                        int loadingblue = 1;
                                        // String? fall='0';
                                        // print('fall');
                                        // print(fall);

                                        for (int x = 0; x < p.data!.length; x++) {
                                          if (widget.username ==
                                              p.data![x].username) {
                                            name = p.data![x].name;
                                            cont = p.data![x].contact;
                                            crtkint = p.data![x].caretaker_id;
                                            // print(name);
                                          }
                                        }
                                        for (int y = 0; y < c.data!.length; y++) {
                                          if (crtkint == c.data![y].caretaker_id) {
                                            crtk = c.data![y].name;
                                            crtkcon = c.data![y].contact;
                                          }
                                        }


                                        // return Container(
                                        //   child: Center(
                                        //     child: CircularProgressIndicator(),
                                        //   ),
                                        // );


                                        if(snapshotblue.data != null) {

                                          refreshAll(
                                              snapshotblue.data![2].characteristics[0],
                                              snapshotblue.data![2].characteristics[1],
                                              snapshotblue.data![2].characteristics[2],
                                              snapshotblue.data![2].characteristics[3],
                                              snapshotblue.data![2].characteristics[4],
                                              snapshotblue.data![2].characteristics[5]);

                                          return ListView(
                                            children: <Widget>[
                                              Divider(),
                                              ListTile(
                                                  title: Text(
                                                      'Welcome, ' +
                                                          widget.username +
                                                          '!',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .bold
                                                      )
                                                  )
                                              ),
                                              Divider(),
                                              ListTile(
                                                // leading: Icons.add_location,
                                                  title:
                                                  // Text('Current location: 13 Tampines Ave 1',
                                                  Text('Current location: ' +
                                                      currloc.toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600
                                                      )
                                                  )
                                              ),
                                              Divider(),
                                              ListTile(
                                                title: Text(
                                                    'Connected to Epilepsy Device ' +
                                                        widget.device.name),
                                              ),
                                              Divider(),
                                              SizedBox(height: 10),

                                              StreamBuilder<List<int>>(
                                                  stream: snapshotblue.data![2]
                                                      .characteristics[2].value,
                                                  builder: (c, snapshot2) {
                                                    if (!snapshot2.hasData) {
                                                      return Center(
                                                          child: CircularProgressIndicator());
                                                    }
                                                    if (snapshot2.data != null) {

                                                      return ListTile(
                                                        leading: Image.asset(
                                                          'heart.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        title: Text('Heart Rate: ' +
                                                            ascii.decode(
                                                                snapshot2.data!)
                                                                .toString() +
                                                            ' bpm'),
                                                        // trailing: RaisedButton(
                                                        //     child: Text('Read heart rate'),
                                                        //     color: Colors.black,
                                                        //     textColor: Colors.white,
                                                        //     onPressed: () async {
                                                        //       refresh(snapshotblue.data![2].characteristics[2]);
                                                        //     }
                                                        // ),
                                                      );
                                                    }
                                                    else {
                                                      return Center(
                                                          child: CircularProgressIndicator());
                                                    }
                                                  }
                                              ),
                                              SizedBox(height: 12),
                                              StreamBuilder<List<int>>(
                                                  stream: snapshotblue.data![2]
                                                      .characteristics[1].value,
                                                  builder: (c1, snapshot3) {
                                                    if (!snapshot3.hasData) {
                                                      return Container(
                                                        child: Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot3.data != null) {
                                                      return ListTile(
                                                        leading: Image.asset(
                                                          'brain.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        title:
                                                        Text('Stress level:  ' + ascii.decode(
                                                            snapshot3.data!)
                                                            .toString() + '/100'),
                                                        // Text('Stress level:  ' +
                                                        //     ascii.decode(
                                                        //         snapshot3.data!) +
                                                        //     '/100'),
                                                        // trailing: RaisedButton(
                                                        //     child: Text(
                                                        //         'Read stress level'),
                                                        //     color: Colors.black,
                                                        //     textColor: Colors.white,
                                                        //     onPressed: () async {
                                                        //       await snapshotblue
                                                        //           .data![2]
                                                        //           .characteristics[1]
                                                        //           .setNotifyValue(
                                                        //           !snapshotblue
                                                        //               .data![2]
                                                        //               .characteristics[1]
                                                        //               .isNotifying);
                                                        //     }
                                                        // ),
                                                      );
                                                    }
                                                    else {
                                                      return Container(
                                                        child: Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),
                                              SizedBox(height: 12),
                                              StreamBuilder<List<int>>(
                                                  stream: snapshotblue.data![2]
                                                      .characteristics[3].value,
                                                  builder: (c2, snapshot4) {
                                                    if (!snapshot4.hasData) {
                                                      return Container(
                                                        child: Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot4.data != null) {
                                                      return ListTile(
                                                        leading: Image.asset(
                                                          'shoe.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        title: Text(
                                                            'Steps taken: ' +
                                                                ascii.decode(
                                                                    snapshot4.data!)
                                                                    .toString() +
                                                                ' steps'),
                                                        // trailing: RaisedButton(
                                                        //     child: Text('Read steps'),
                                                        //     color: Colors.black,
                                                        //     textColor: Colors.white,
                                                        //     onPressed: () async {refresh(snapshotblue.data![2].characteristics[3]);}
                                                        // ),
                                                      );
                                                    }
                                                    else {
                                                      return Container(
                                                        child: Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                  }

                                              ),
                                              SizedBox(height: 12),

                                              ListTile(
                                                title: ElevatedButton(
                                                    child: const Text(
                                                        'View history'),
                                                    onPressed: () async {
                                                      await Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return HistoryPage(
                                                              id: widget.id,
                                                              name: name,
                                                            caretakername: null,
                                                            caretakerid: null,
                                                            role: widget.role);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              ListTile(
                                                title: ElevatedButton(
                                                    child: const Text(
                                                        'View your info'),
                                                    onPressed: () async {
                                                      final ble
                                                          .BluetoothDevice? selectedDevice =
                                                      await Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return InfoPage(
                                                                username: widget
                                                                    .username,
                                                                role: widget.role);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              Divider(),
                                            ],
                                          );
                                        }
                                        else {
                                          return Container(
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  );
                                }
                            );
                          });
                    })
            )
        ));
  }

  refresh(ble.BluetoothCharacteristic c) async {
    await c.setNotifyValue(true);
    // print('notifying');
    await c.read();
    // print (c.read().toString());
  }
  refreshAll(ble.BluetoothCharacteristic c, ble.BluetoothCharacteristic c1, ble.BluetoothCharacteristic c2, ble.BluetoothCharacteristic c3, ble.BluetoothCharacteristic c4, ble.BluetoothCharacteristic c5) async {
    await refresh(c);
    Future.delayed(const Duration(
        milliseconds: 2000), () async {
      await refresh(c1);
    });
    Future.delayed(const Duration(
        milliseconds: 4000), () async {
      await refresh(c2);
    });
    Future.delayed(const Duration(
        milliseconds: 6000), () async {
      await refresh(c3);
    });
    Future.delayed(const Duration(
        milliseconds: 8000), () async {
      await refresh(c4);
    });
    Future.delayed(const Duration(
        milliseconds: 10000), () async {
      await refresh(c5);
    });
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

  showDisconnectDialog(BuildContext context) {
    // Create button
    Widget YesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () async{
        // FlutterBackgroundService()
        //     .sendData({"action": "setAsBackground"});
        await widget.device.disconnect();
        FlutterBackgroundService()
            .sendData({"hr": ''});
        FlutterBackgroundService()
            .sendData({"action": "setAsBackground"});
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainPage(username: widget.username, role: widget.role, id: widget.id, succ: 1, conn: 0, device: null);
            },
          ),
        );
        Navigator.of(context).pop();
      },
    );
    Widget NoButton = RaisedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertDisc = AlertDialog(
      title: Text("Disconnect from device"),
      content: Text("Do you wish to disconnect?"),
      actions: [
        YesButton, NoButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDisc;
      },
    );
  }

}