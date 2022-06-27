import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:epimon2/MainPageConnected_2.dart';
import 'package:epimon2/MainPage.dart';
import 'package:epimon2/Warning2.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
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
  final String crtkcon;
  final String cont;
  // final StreamSubscription<List<int>?> subscription;
  const CallingPage({required this.server, required this.username, required this.name, required this.role, required this.id, required this.loc, required this.hrlist, required this.crtkcon, required this.cont});
  @override
  _CallingPageState createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final Telephony telephony = Telephony.instance;
  StreamSubscription<List<int>?>? subscriptionhr;
  StreamSubscription<List<int>?>? subscriptionstress;
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
    String timebegin= "'" + DateTime.now().toString()+ "'";
    String timeend= "";
    // double Stress= 0.0;
    double hr= 0.0;
    double str= 0.0;
    int epi=1;
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
                print(contact);

                contactstr= contact.toString().replaceAll(",", ".");
                // VolumeController().maxVolume();
                String msg= 'There is an emergency at ' + widget.loc.toString() + ', ' + widget.name + 'is having a seizure and is in need of aid. Their contact number is.' + contactstr;
                speak(msg, epi);
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

                subscriptionhr =
                    snapshot.data![2].characteristics[2].value.listen((event) {
                      hrstring = ascii.decode(event).toString();
                      if (hrstring != null) {
                        hr = int.parse(hrstring!).toDouble();
                        // List<double> hrlistdouble=[];
                        hrlist.add(hr);
                        print('calling');
                      }
                      print(hrlist);
                    });

                subscriptionstress =
                    snapshot.data![2].characteristics[1].value.listen((event) {
                      strstring = ascii.decode(event).toString();
                      if(strstring!=null) {
                        str = int.parse(strstring!).toDouble();
                        // List<double> hrlistdouble=[];
                        strlist.add(str);
                        print('wrning');
                        print(strlist);
                      }
                      // subscriptionhr?.cancel();
                    });
                // if(epi==0) {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) {
                //         subscriptionhr.cancel();
                //         return MainPageConnected(
                //             username: widget.username,
                //             role: widget.role,
                //             id: widget.id,
                //             device: widget.server,
                //             epi: widget.epi);
                //       },
                //     ),
                //   );
                // }

                //postData(hrstring);
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
                      // ListTile(
                      //   title: ElevatedButton(
                      //       child: const Text('call'),
                      //       onPressed: () async {
                      //         print(widget.crtkcon);
                      //         // await FlutterPhoneDirectCaller.callNumber(widget.crtkcon);
                      //         // await FlutterPhoneDirectCaller.callNumber("+65 67840118");
                      //       }),
                      // ),
                      ListTile(
                        title: ElevatedButton(
                            child: const Text('Patient has recovered'),
                            onPressed: () {
                              epi = 0;
                              subscriptionhr!.cancel();
                              subscriptionstress!.cancel();
                              timeend = "'" + DateTime.now().toString() + "'";
                              postData(hrlist, strlist, timebegin, timeend);
                              hrlist.clear();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    subscriptionhr!.cancel();
                                    subscriptionstress!.cancel();
                                    return MainPage(
                                        username: widget.username,
                                        role: widget.role,
                                        id: widget.id,
                                        succ: 1
                                      // device: widget.server,
                                    );
                                  },
                                ),
                              );
                            }),
                      ),

                      // ListTile(
                      //   title: ElevatedButton(
                      //       child: const Text('to warning'),
                      //       onPressed: () {
                      //         subscriptionhr.cancel();
                      //         timeend = "'" + DateTime.now().toString() + "'";
                      //         // postData(hrlist, timebegin, timeend);
                      //         hrlist.clear();
                      //         Navigator.of(context).push(
                      //           MaterialPageRoute(
                      //             builder: (context) {
                      //               return WarningPage2(
                      //                   username: widget
                      //                       .username,
                      //                   role: widget.role,
                      //                   id: widget.id,
                      //                   server: widget
                      //                       .server,
                      //                   // epi: 1,
                      //                   loc: widget.loc
                      //                       .toString(),
                      //                   // hrlist:[],
                      //                   crtkcon: widget.crtkcon
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       }),
                      // ),
                      // ListTile(
                      //     title: Center(
                      //         child: Text("This phone is currently contacting an ambulance. If help has yet to arrive within 3 minutes, please help by calling 995.",
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.white
                      //             )
                      //         )
                      //     )
                      // ),
                    ]
                );


                /////////////////////////////
                return Container(
                  child: Center(child: CircularProgressIndicator(),
                  ),
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
  postData(List<double> hrlist, List<double> strlist, String timebegin, String timeend)async{ //post dt to server
    //final JSONObject dataJson = new JSONObject();
    print('hrlist:');
    print(hrlist);
    print('strlist:');
    print(strlist);
    double addedHr=0;
    double avgHr=0;
    double addedStr=0;
    double avgStr=0;
    for (int i=0; i<hrlist.length; i++) {
      addedHr= addedHr+ hrlist[i];
    }
    for (int y=0; y<strlist.length; y++) {
      addedStr= addedStr+ hrlist[y];
    }
    avgHr= addedHr/hrlist.length;
    avgStr= addedStr/strlist.length;
    Map<String, dynamic> jsonMp= {
      "Stress": avgStr.toString(),
      "AccelerometerX": "3.10",
      "AccelerometerY": "2.10",
      "AccelerometerZ": "4.10",
      "HeartRate": avgHr.toString(),
      "timestart": timebegin ,
      "timestop": timeend,
      "Gyroscopic_Changes": "1",
      "patient_id": widget.id.toString(),
      "heartrate_history": "'" + hrlist.toString() + "'"
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
    //await Future.delayed(Duration(milliseconds: 500));
  }

  speak(String msg, int epi) async {
    for (int i=0; i<2; i++) {
      FlutterTts fluttertts = new FlutterTts();
      if (epi == 1) {
        await fluttertts.speak(msg);
        await fluttertts.awaitSpeakCompletion(true);
      }
      else {
        fluttertts.stop();
      }
    }
    // Future.delayed(const Duration(milliseconds:4000));
  }
}