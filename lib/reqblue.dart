import 'package:epimon2/reqblueconn.dart';
import 'package:epimon2/reqphone.dart';
import 'package:flutter/material.dart';
import 'package:epimon2/MainPage.dart';
import 'package:permission_handler/permission_handler.dart';

class reqblue extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqblue({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqblue createState() => new _reqblue();
}

class _reqblue extends State<reqblue> {

  @override
  void initState() {
    super.initState();
    checkBluetooth();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    // if (loc.PermissionStatus.granted == true) {
    //
    // }
    // print('reqblue');
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

                ))
        )
    );
  }
  checkBluetooth() async {
    var bluestt= await Permission.bluetooth.status;

    // print('stt ' + bluestt.toString());

    if (bluestt == PermissionStatus.denied) {
      bluestt = await Permission.bluetooth.request();
      if (bluestt !=  PermissionStatus.granted) {
        return;
      }
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqblueconn(username: widget.username,
                  role: widget.role,
                  id: widget.id,
                  succ: widget.succ);
            },
          ),
        );
      }
    }
    else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return reqblueconn(username: widget.username,
                role: widget.role,
                id: widget.id,
                succ: widget.succ);
          },
        ),
      );
    }
  }
}