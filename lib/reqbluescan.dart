import 'package:epimon2/reqphone.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class reqbluescan extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqbluescan({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqbluescan createState() => new _reqbluescan();
}

class _reqbluescan extends State<reqbluescan> {

  @override
  void initState() {
    super.initState();
    checkBlueScan();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    // if (loc.PermissionStatus.granted == true) {
    //
    // }
    // print('reqbluescan');
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
  checkBlueScan() async {
    var bluescan= await Permission.bluetoothScan.status;
    //
    // print(bluescan);

    if (bluescan ==PermissionStatus.denied) {
      bluescan= await Permission.bluetoothScan.request();
      if (bluescan.isGranted == PermissionStatus.denied) {
        return;
      }
      else {
        // print('bluescan: ' + bluescan.toString());
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqphone(username: widget.username,
                role: widget.role,
                id: widget.id,
                succ: widget.succ,
              );
            },
          ),
        );
      }
    }
    else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return reqphone(username: widget.username,
              role: widget.role,
              id: widget.id,
              succ: widget.succ,
            );
          },
        ),
      );
    }
  }
}