import 'package:epimon2/reqloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:epimon2/Signup.dart';
import 'package:epimon2/Signup_caretaker.dart';

import './Login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LandingPage extends StatefulWidget {
  @override
  _LandingPage createState() => new _LandingPage();
}
class _LandingPage extends State<LandingPage>{
  @override

  //if()
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    // ser.FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    // _collectingTask?.dispose();
    super.dispose();

  }

  checkLoggedIn(BuildContext context) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    var user= preferences.getString('user');
    var role= preferences.getString('role');
    var id= preferences.getInt('id');
    if(user!=null && user != '') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return reqloc(username: user, role: role!, id: id!, succ: 1);
          },
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print('at main');
    checkLoggedIn(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('EpiMon'),

        ),
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(

                      children: <Widget>[
                        Text(
                          "Welcome!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:30
                          ),
                        ),
                        SizedBox(height:20),
                        Column(
                          children: <Widget>[
                            MaterialButton(
                              minWidth: double.infinity,
                              height:60,
                              onPressed: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return LoginPage();
                                    },
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text("Login",
                                style:TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:18,
                                ),
                              ),
                            ),
                            SizedBox(height:20),
                            MaterialButton(
                                minWidth: double.infinity,
                                height:60,
                                onPressed: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return _RegisterRolePage();
                                      },
                                    ),
                                  );
                                },
                                color:Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:Text("Register",
                                    style:TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18
                                    )
                                )
                            ),
                          ],
                        )
                      ]
                  ),
                  // Container(
                  //   height: MediaQuery.of(context).size.height,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/Heart.svg.png')
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ))
    );
  }

}

class _RegisterRolePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('EpiMon'),
        ),
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(

                      children: <Widget>[
                        Text(
                          "Are you an epilepsy patient or a caretaker?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:20
                          ),
                        ),
                        SizedBox(height:20),
                        // SizedBox(
                        //   height: 10,
                        // // ),
                        // Text('u poppin p',
                        //   textAlign: TextAlign.center,
                        //   style:TextStyle(
                        //     color:Colors.grey[700],
                        //     fontSize: 15,
                        //   ),
                        // ),
                        Column(
                          children: <Widget>[
                            MaterialButton(
                              minWidth: double.infinity,
                              height:60,
                              onPressed: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignupPage();
                                    },
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text("Epilepsy Patient",
                                style:TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:18,
                                ),
                              ),
                            ),
                            SizedBox(height:20),
                            MaterialButton(
                                minWidth: double.infinity,
                                height:60,
                                onPressed: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SignupCaretakerPage();
                                      },
                                    ),
                                  );
                                },
                                color:Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:Text("Caretaker",
                                    style:TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18
                                    )
                                )
                            ),
                          ],
                        )
                      ]
                  ),
                  // Container(
                  //   height: MediaQuery.of(context).size.height,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/Heart.svg.png')
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ))
    );
  }

}