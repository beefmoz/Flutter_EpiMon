import 'dart:async';

import 'package:epimon2/Calling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:volume_controller/volume_controller.dart';


class WarningPage2 extends StatefulWidget {
  final BluetoothDevice? server;
  final String username;
  final String name;
  final String role;
  final int id;
  final String loc;
  final String cont;
  final crtkcon;
  const WarningPage2({required this.server, required this.username, required this.name, required this.role  , required this.id, required this.loc, required this.crtkcon, required this.cont});
  @override
  _WarningPageState2 createState() => _WarningPageState2();
}

off(BluetoothCharacteristic c) async {
  await c.setNotifyValue(false);
}

class _WarningPageState2 extends State<WarningPage2> {
  final FlutterTts fluttertts = FlutterTts();
  StreamSubscription<List<int>?>? subscriptionhr;
  StreamSubscription<List<int>?>? subscriptionstress;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    subscriptionhr!.cancel();
    subscriptionstress!.cancel();
    // subscriptionacc!.cancel();
  }

  Widget build(BuildContext context) {
    String? hrstring;
    String timebegin = "'" + DateTime.now().toString() + "'";
    String? strstring;
    String timeend = "";
    double hr = 0.0;
    double str= 0.0;
    int epi=1;
    List<double> hrlist = [];
    List<double> strlist = [];

    // widget.server.discoverServices();

    // print('at warning page');

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        body: Container(
          child: StreamBuilder<List<BluetoothService>?>(
              stream: widget.server!.services,
              builder: (c, snapshot)
              {
                if (!snapshot.hasData) {
                  // print('error: ');
                  // print(bghr.error?.toString());
                  return Container(
                    child: Center(child: CircularProgressIndicator(),
                    ),
                  );
                }
                VolumeController().maxVolume();
                fluttertts.speak(
                    "Warning. This person is currently having a seizure. please do the following. 1. Ensure no dangerous objects are near the person. 2. Do not put any objects near the person's mouth. 3. Stay away from the person once first 2 mentioned conditions are met.");

                // off(snapshot.data![2].characteristics[4]);
                hrlist.clear();
                strlist.clear();

                subscriptionhr =
                    snapshot.data![2].characteristics[2].value.listen((event) {
                      hrstring = ascii.decode(event).toString();
                      if(hrstring!=null) {
                        hr = int.parse(hrstring!).toDouble();
                        // List<double> hrlistdouble=[];
                        hrlist.add(hr);
                        // print('wrning');
                        // print('hr');
                        // print(hrlist);
                      }
                      // subscriptionhr?.cancel();
                    });

                subscriptionstress =
                    snapshot.data![2].characteristics[1].value.listen((event) {
                      strstring = ascii.decode(event).toString();
                      if(strstring!=null) {
                        str = int.parse(strstring!).toDouble();
                        // List<double> hrlistdouble=[];
                        strlist.add(str);
                        // print('wrning');
                        // print(strlist);
                      }
                      // subscriptionhr?.cancel();
                    });
                // print('before delay');
                Future.delayed(const Duration(milliseconds: 21000), () async {
                  // await subscriptionhr.cancel();
                  subscriptionhr!.cancel();
                  subscriptionstress!.cancel();
                  if(epi==1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CallingPage(
                              username: widget.username,
                              name: widget.name,
                              id: widget.id,
                              role: widget.role,
                              server: widget.server,
                              loc: widget.loc,
                              hrlist: hrlist,
                              strlist: strlist,
                              crtkcon: widget.crtkcon,
                              cont: widget.cont
                          );
                        },
                      ),
                    );
                  }
                  else {
                    // print('nope');
                  }
                }
                );
                  return ListView(
                      children: <Widget>[
                        SizedBox(height: 50,),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('Warning.png',
                              height: 275,
                              width: 275,
                            )
                        ),
                        SizedBox(height: 50,),
                        ListTile(
                            title: Center(
                                child: Text(
                                    'This person is currently having a seizure. please do the following:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                            )
                        ),
                        SizedBox(height: 10,),
                        ListTile(
                            title: Center(
                                child: Text(
                                    '1. Ensure no dangerous objects are near the person.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )
                                )
                            )
                        ),
                        SizedBox(height: 10,),
                        ListTile(
                            title: Center(
                                child: Text(
                                    "2. Do not put any objects near the person's mouth.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    )
                                )
                            )
                        ),
                        SizedBox(height: 10,),
                        ListTile(
                            title: Center(
                                child: Text(
                                    "3. Stay away from the person once first 2 mentioned conditions are met.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    )
                                )
                            )
                        ),
                        SizedBox(height: 20,),
                      ]
                  );
                })
              ),
        );
  }
}