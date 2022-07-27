import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:epimon2/reqblue.dart';

class reqloc extends StatefulWidget {
  final String username;
  final int id;
  final int succ;
  final String role;
  const reqloc({required this.username, required this.role, required this.id, required this.succ});
  @override
  _reqloc createState() => new _reqloc();
}

class _reqloc extends State<reqloc> {
  var location = new loc.Location();

  @override
  void initState() {
    super.initState();
    checklocperm();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    // if (loc.PermissionStatus.granted == true) {
    //
    // }
    // print('reqloc');
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

  checklocservice() async {
    var serviceEnabled = await location.serviceEnabled();
    // print(serviceEnabled);
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  checklocperm() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
      else {
        checklocservice();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return reqblue(username: widget.username,
                  role: widget.role,
                  id: widget.id,
                  succ: widget.succ);
            },
          ),
        );
      }
    }
    else {
      checklocservice();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return reqblue(username: widget.username,
                role: widget.role,
                id: widget.id,
                succ: widget.succ);
          },
        ),
      );
    }
  }
}
