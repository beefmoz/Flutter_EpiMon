import 'package:flutter/material.dart';
import 'package:epimon2/MainPage.dart';
import 'package:permission_handler/permission_handler.dart';

class reqnotif extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqnotif({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqnotif createState() => new _reqnotif();
}

class _reqnotif extends State<reqnotif> {

  @override
  void initState() {
    super.initState();
    checkNotifPerm();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    // if (loc.PermissionStatus.granted == true) {
    //
    // }
    // print('reqnotif');
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
  checkNotifPerm() async {
    var windowGranted = await Permission.systemAlertWindow.status;

    if (windowGranted ==PermissionStatus.denied) {
      windowGranted= await Permission.systemAlertWindow.request();
      if (windowGranted.isGranted == PermissionStatus.denied) {
        return;
      }
      else {
        // print('notifperm: ' + windowGranted.toString());
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainPage(username: widget.username,
                  role: widget.role,
                  id: widget.id,
                  succ: widget.succ,
                  conn: 0,
                  device: null
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
            return MainPage(username: widget.username,
                role: widget.role,
                id: widget.id,
                succ: widget.succ,
                conn: 0,
                device: null
            );
          },
        ),
      );
    }
  }
}