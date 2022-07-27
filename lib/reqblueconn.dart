import 'package:epimon2/reqbluescan.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class reqblueconn extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqblueconn({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqblueconn createState() => new _reqblueconn();
}

class _reqblueconn extends State<reqblueconn> {

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
    var blueconn= await Permission.bluetoothConnect.status;

    // print('stt ' + blueconn.toString());

    if (blueconn == PermissionStatus.denied) {
      blueconn = await Permission.bluetoothConnect.request();
      if (blueconn !=  PermissionStatus.granted) {
        return;
      }
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqbluescan(username: widget.username,
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
            return reqbluescan(username: widget.username,
                role: widget.role,
                id: widget.id,
                succ: widget.succ);
          },
        ),
      );
    }
  }
}