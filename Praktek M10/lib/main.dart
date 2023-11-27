import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact.dart';
import 'camera.dart';
import 'location.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int noCount = 0;

  void _showPermissionDialog(
      String permissionName, Function onGranted, Function onDenied) {
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
                _showSettingsDialog(); // Show settings dialog for permanent denial
              } else {
                onDenied();
              }
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              var status = await Permission.camera.request();
              if (status == PermissionStatus.granted) {
                onGranted();
              } else if (status == PermissionStatus.permanentlyDenied) {
                _openAppSettings(); // Open app settings for permanent denial
              } else {
                onDenied();
              }
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text(
          "You have denied the permission multiple times. "
          "Please go to app settings to grant the permission.",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _openAppSettings() async {
    await openAppSettings();
  }

  void contact() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ContactScreen()));
    } else {
      _showPermissionDialog(
        "contact",
        () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ContactScreen()));
        },
        () {
          // Handle denial or "No" here
        },
      );
    }
  }

  void camera() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    } else {
      _showPermissionDialog(
        "camera",
        () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CameraScreen()));
        },
        () {
          // Handle denial or "No" here
        },
      );
    }
  }

  void location() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LocationScreen()));
    } else {
      _showPermissionDialog(
        "location",
        () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LocationScreen()));
        },
        () {
          // Handle denial or "No" here
        },
      );
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
