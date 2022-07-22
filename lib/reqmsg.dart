import 'package:epimon2/reqnotif.dart';
import 'package:flutter/material.dart';
import 'package:epimon2/MainPage.dart';
import 'package:permission_handler/permission_handler.dart';

class reqmsg extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqmsg({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqmsg createState() => new _reqmsg();
}

class _reqmsg extends State<reqmsg> {

  @override
  void initState() {
    super.initState();
    checkMsg();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    // if (loc.PermissionStatus.granted == true) {
    //
    // }
    // print('reqphone');
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
  checkMsg() async {
    var msgperm= await Permission.sms.status;

    // print(phoneperm);

    if (msgperm ==PermissionStatus.denied) {
      msgperm= await Permission.sms.request();
      if (msgperm.isGranted == PermissionStatus.denied) {
        return;
      }
      else {
        // print('phoneperm: ' + phoneperm.toString());
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqnotif(username: widget.username,
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
            return reqnotif(username: widget.username,
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