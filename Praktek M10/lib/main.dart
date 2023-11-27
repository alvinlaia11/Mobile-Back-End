import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int noCount = 0;

  void _showPermissionDialog(String permissionName, Function onGranted) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text("This app requires $permissionName permission."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              noCount++;
              if (noCount >= 3) {
                noCount = 0;
                openAppSettings(); // Open app settings for permanent denial
              }
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              var status = await PermissionHandler().request(
                Permission.contacts,
              );
              if (status == PermissionStatus.granted) {
                onGranted();
              } else if (status == PermissionStatus.permanentlyDenied) {
                openAppSettings();
              }
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void contact() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else {
      _showPermissionDialog("contact", () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactScreen()));
      });
    }
  }

  void camera() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      // Add camera screen navigation logic here
    } else {
      _showPermissionDialog("camera", () {
        // Add camera screen navigation logic here
      });
    }
  }

  void location() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      // Add location screen navigation logic here
    } else {
      _showPermissionDialog("location", () {
        // Add location screen navigation logic here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: contact, child: Text("Contact")),
            ElevatedButton(onPressed: camera, child: Text("Camera")),
            ElevatedButton(onPressed: location, child: Text("Location")),
          ],
        ),
      ),
    );
  }
}
