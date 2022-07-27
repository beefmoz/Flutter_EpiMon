import 'package:epimon2/reqmsg.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class reqphone extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqphone({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqphone createState() => new _reqphone();
}

class _reqphone extends State<reqphone> {

  @override
  void initState() {
    super.initState();
    checkPhone();
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
  checkPhone() async {
    var phoneperm= await Permission.phone.status;

    // print(phoneperm);

    if (phoneperm ==PermissionStatus.denied) {
      phoneperm= await Permission.phone.request();
      if (phoneperm.isGranted == PermissionStatus.denied) {
        return;
      }
      else {
        // print('phoneperm: ' + phoneperm.toString());
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqmsg(username: widget.username,
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
            return reqmsg(username: widget.username,
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