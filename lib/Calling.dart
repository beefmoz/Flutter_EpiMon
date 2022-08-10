import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:epimon2/MainPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:telephony/telephony.dart';
import 'package:volume_controller/volume_controller.dart';

class CallingPage extends StatefulWidget {
  final BluetoothDevice? server;
  final String username;
  final String name;
  final String role;
  final int id;
  final String loc;
  final List<double> hrlist;
  final List<double> strlist;
  final String crtkcon;
  final String cont;
  // final StreamSubscription<List<int>?> subscription;
  const CallingPage({required this.server, required this.username, required this.name, required this.role, required this.id, required this.loc, required this.hrlist, required this.strlist, required this.crtkcon, required this.cont});
  @override
  _CallingPageState createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final Telephony telephony = Telephony.instance;
  StreamSubscription<List<int>?>? subscriptionhr;
  StreamSubscription<List<int>?>? subscriptionstress;
  StreamSubscription<List<int>?>? subscriptionacc;
  StreamSubscription<List<int>?>? subscriptiongyro;
  final FlutterTts fluttertts = FlutterTts();

  @override

  void initState() {
    super.initState();
    // toInit();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    subscriptionhr!.cancel();
    subscriptionstress!.cancel();
    widget.server!.discoverServices();
  }

  Widget build(BuildContext context) {
    String? hrstring;
    String? strstring;
    String? accstring;
    List acclist= [];
    String? gyrostring;
    List gyrolist= [];
    String timebegin= "'" + DateTime.now().toString()+ "'";
    String timeend= "";
    // double Stress= 0.0;
    double hr= 0.0;
    double str= 0.0;
    String x= '';
    String y= '';
    String z= '';
    String gyromag= '0';
    int epi=1;
    int prevmillishr=DateTime.now().millisecondsSinceEpoch;
    int currmillishr= 0;
    int prevmillisstr=DateTime.now().millisecondsSinceEpoch;
    int currmillisstr= 0;
    List<double> hrlist= [];
    List<double> strlist = [];
    List<String> contact;
    String contactstr;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
            child: StreamBuilder<List<BluetoothService>>(
              stream: widget.server!.services,
              builder: (c, snapshot)
              {
                // final service = FlutterBackgroundService();
                // service.start();
              while(epi==1) {
                contact= widget.cont.split("");
                // print(contact);

                contactstr= contact.toString().replaceAll(",", ".");
                VolumeController().maxVolume();

                FlutterPhoneDirectCaller.callNumber(widget.crtkcon);

                String msg= 'There is an emergency at ' + widget.loc.toString() + ', ' + widget.name + 'is having a seizure and is in need of aid. Their contact number is.' + contactstr;
                speak(msg, epi);
                Timer.periodic(const Duration(seconds: 15), (timer) {
                  speak(msg, epi);
                  if (epi == 0) {
                    timer.cancel();
                  }
                });
                if (!snapshot.hasData) {
                  // print('error: ');
                  // print(bghr.error?.toString());
                  return Container(
                    child: Center(child: CircularProgressIndicator(),
                    ),
                  );
                }

                for (int i = 0; i < widget.hrlist.length; i++) {
                  hrlist.add(widget.hrlist[i]);
                }

                for (int i = 0; i < widget.strlist.length; i++) {
                  strlist.add(widget.strlist[i]);
                }

                subscriptionhr =
                    snapshot.data![2].characteristics[2].value.listen((event) {
                      currmillishr= DateTime.now().millisecondsSinceEpoch;
                      hrstring = ascii.decode(event).toString();
                      if(hrstring!=null) {
                        hr = int.parse(hrstring!).toDouble();
                      }
                      if(currmillishr>= prevmillishr+10000) {
                        hrlist.add(hr);
                        // print('wrning');
                        // print('hr');
                        // print(hrlist);
                        prevmillishr= currmillishr;
                      }
                      // subscriptionhr?.cancel();
                    });

                subscriptionstress =
                    snapshot.data![2].characteristics[1].value.listen((event) {
                      currmillisstr= DateTime.now().millisecondsSinceEpoch;
                      strstring = ascii.decode(event).toString();
                      if(strstring!=null) {
                        str = int.parse(strstring!).toDouble();
                      }
                      if(currmillisstr>= prevmillisstr+10000) {
                        strlist.add(str);
                        // print('wrning');
                        // print('stress');
                        // print(strlist);
                        prevmillisstr= currmillisstr;
                      }
                      // subscriptionstress?.cancel();
                    });

                subscriptionacc =
                    snapshot.data![2].characteristics[4].value.listen((event) {
                      accstring = ascii.decode(event).toString();
                      if(accstring!=null) {
                        acclist= accstring!.split(",");
                        // print('acclist');
                        // print(acclist);
                        x= acclist[0];
                        y= acclist[1];
                        z= acclist[2];
                        // print(x);
                        // print(y);
                        // print(z);
                      }
                      // subscriptionhr?.cancel();
                    });

                subscriptiongyro =
                    snapshot.data![2].characteristics[5].value.listen((event) {
                      gyrostring = ascii.decode(event).toString();
                      if(gyrostring!=null) {
                        gyrolist= gyrostring!.split(",");
                        gyromag= gyrolist[3];
                        // print('gyrolst');
                        // print(gyromag);
                        // gyrolist.add(int.parse(gyromag).toDouble());
                      }
                      // subscriptionhr?.cancel();
                    });

                return ListView(
                    children: <Widget>[
                      SizedBox(height: 50,),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset('phone.png',
                            height: 275,
                            width: 275,
                          )
                      ),
                      SizedBox(height: 50,),
                      ListTile(
                          title: Center(
                              child: Text('Emergency detected.',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          )
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                          title: Center(
                              child: Text('Calling 995 from',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )
                              )
                          )
                      ),
                      //SizedBox(height: 10,),
                      ListTile(
                          title: Center(
                              child: Text(widget.loc,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    // color: Colors.white
                                  )
                              )
                          )
                      ),
                      SizedBox(height: 20,),

                      ListTile(
                        title: ElevatedButton(
                            child: const Text('Patient has recovered'),
                            onPressed: () {
                              epi= 0;
                              subscriptionhr!.cancel();
                              subscriptionstress!.cancel();
                              subscriptionacc!.cancel();
                              subscriptiongyro!.cancel();
                              snapshot.data![2].characteristics[0].write(utf8.encode('0'));
                              timeend = "'" + DateTime.now().toString() + "'";
                              postData(hrlist, strlist, timebegin, timeend, x, y, z, gyromag);
                              hrlist.clear();
                              strlist.clear();
                              fluttertts.stop();
                              showAlertDialog(context);
                            }),
                      ),
                    ]
                );
              }
              return Container(
                child: Center(child: CircularProgressIndicator(),
                ),
              );
              },
            )
        )
    );
  }
  postData(List<double> hrlist, List<double> strlist, String timebegin, String timeend, String x, String y, String z, String gyro)async{ //post dt to server
    //final JSONObject dataJson = new JSONObject();
    // print('hrlist:');
    // print(hrlist);
    // print('strlist:');
    // print(strlist);
    double addedHr=0;
    double avgHr=0;
    double addedStr=0;
    double avgStr=0;
    if(gyro=='') {
      gyro= '0';
    }
    for (int i=0; i<hrlist.length; i++) {
      addedHr= addedHr+ hrlist[i];
    }
    for (int y=0; y<strlist.length; y++) {
      addedStr= addedStr+ strlist[y];
    }
    avgHr= addedHr/hrlist.length;
    avgStr= addedStr/strlist.length;
    Map<String, dynamic> jsonMp= {
      "Stress": avgStr.toString(),
      "AccelerometerX": x,
      "AccelerometerY": y,
      "AccelerometerZ": z,
      "HeartRate": avgHr.toString(),
      "timestart": timebegin ,
      "timestop": timeend,
      "Gyroscopic_Changes": gyro,
      "patient_id": widget.id.toString(),
      "heartrate_history": "'" + hrlist.toString() + "'",
      "stress_history": "'" + strlist.toString() + "'",
      "notes": "' '",

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
      // print("Error");
      // print(e);
    }
    //await Future.delayed(Duration(milliseconds: 500));
  }

  speak(String msg, int epi) async {
      FlutterTts fluttertts = new FlutterTts();
      if (epi == 1) {
        await fluttertts.speak(msg);
        await fluttertts.awaitSpeakCompletion(true);
      }
      else {
        fluttertts.stop();
      }
    // Future.delayed(const Duration(milliseconds:4000));
  }
  showAlertDialog(BuildContext context) {
    // Create button
    Widget successButton = RaisedButton(
      child: Text("OK"),
      onPressed: () async{
        SystemNavigator.pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertSuccess = AlertDialog(
      title: Text("Recorded readings"),
      content: Text("Your readings have been recorded. The app will now restart. Please take care."),
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