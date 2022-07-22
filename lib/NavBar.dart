import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

import 'EpilepsyHistoryList.dart';
import 'InfoPage.dart';
import 'MainPage.dart';
import 'SelectBondedDevicePage.dart';

class NavBar extends StatefulWidget {
  final String username;
  final String role;
  final int id;
  final String location;
  final BluetoothDevice? device;
  const NavBar({required this.username, required this.role, required this.id, required this.location, required this.device});
  @override
  _NavBar createState() => new _NavBar();
}

class _NavBar extends State<NavBar> {
  var location= new loc.Location();
  String? currloc= '';
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<List<geo.Placemark>>(
            future: checkloc(),
            builder: (context, l) {
              if(l.data==null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              currloc = l.data![0].street;
              if(widget.device==null) {
                return ListView(
                  // Remove padding
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text('Welcome, ' + widget.username),
                      accountEmail: Text('Location: ' + currloc!),
                      currentAccountPicture: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Profile'),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoPage(
                                  username: widget.username,
                                  role: widget.role);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('History'),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return HistoryPage(
                                id: widget.id, name: widget.username,);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Connect to EpiDevice'),
                      onTap: () async {
                        var blueconn= await Permission.bluetoothConnect.status;
                        if (blueconn == PermissionStatus.denied) {
                          blueconn = await Permission.bluetoothConnect.request();
                          if (blueconn !=  PermissionStatus.granted) {
                            return;
                          }
                          else {
                            // print('blueconn: ' + blueconn.toString());
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return FlutterBlueApp(username: widget.username,
                                      role: widget.role,
                                      id: widget.id,
                                      succ: 1);
                                },
                              ),
                            );
                          }
                        }
                        else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return FlutterBlueApp(username: widget.username,
                                    role: widget.role,
                                    id: widget.id,
                                    succ: 1);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              }


              else {
                return ListView(
                  // Remove padding
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text('Welcome, ' + widget.username),
                      accountEmail: Text('Location: ' + currloc!),
                      currentAccountPicture: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Profile'),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoPage(
                                  username: widget.username,
                                  role: widget.role);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('History'),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return HistoryPage(
                                id: widget.id, name: widget.username,);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Disconnect from EpiDevice'),
                      onTap: () async {
                        showDisconnectDialog(context);
                      },
                    ),
                  ],
                );
              }
            }
        )
    );
  }
  Future<List<geo.Placemark>> checkloc() async {
    var currcoord= await location.getLocation();
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(currcoord.latitude!.toDouble(), currcoord.longitude!.toDouble());
    // print(placemarks![0].street);
    return placemarks;
  }

  showDisconnectDialog(BuildContext context) {
    // Create button
    Widget YesButton = RaisedButton(
      child: Text("Yes"),
      onPressed: () async{
        await widget.device!.disconnect();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MainPage(username: widget.username, role: widget.role, id: widget.id, succ: 1, conn: 0, device: null);
            },
          ),
        );
        Navigator.of(context).pop();
      },
    );
    Widget NoButton = RaisedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alertDisc = AlertDialog(
      title: Text("Disconnect from device"),
      content: Text("Do you wish to disconnect?"),
      actions: [
        YesButton, NoButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDisc;
      },
    );
  }
}