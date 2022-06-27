import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as ble;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as ser;
import 'package:scoped_model/scoped_model.dart';
import 'package:epimon2/EpilepsyHistoryList.dart';
import 'package:epimon2/InfoPage.dart';
import 'package:epimon2/Models/Caretaker_Class.dart';

import 'package:epimon2/BackgroundCollectingTask.dart';
import './SelectBondedDevicePage.dart';

import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:epimon2/api_manager.dart';
import 'package:epimon2/reqblue.dart';
import 'package:permission_handler/permission_handler.dart';

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
    print('reqloc');
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
    print(serviceEnabled);
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
    }
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
