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
  bool shouldOpenSettingsDirectly = false;

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
                shouldOpenSettingsDirectly = true;
                Navigator.pop(context); // Close the current screen
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
                noCount = 0; // Reset the count when permission is permanently denied
                shouldOpenSettingsDirectly = true;
                Navigator.pop(context); // Close the current screen
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

  void _openAppSettings() async {
    await openAppSettings();
  }

  void _handlePermission() {
    if (shouldOpenSettingsDirectly) {
      _openAppSettings();
    } else {
      // Handle the permission logic if needed
    }
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
          _handlePermission();
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
          _handlePermission();
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
          _handlePermission();
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
