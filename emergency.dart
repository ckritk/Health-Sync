import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dbHelper.dart';

class EmergencyButton extends StatefulWidget {
  @override
  _EmergencyButtonState createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  int _pressCounter = 0;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _pressCounter++;
        if (_pressCounter == 2) {
          _makePhoneCall();
          _sendLocationViaWhatsApp();
          _pressCounter = 0; // Reset counter after call initiated
        }
      },
      child: Icon(Icons.add_alert),  // Icon for the floating action button
      backgroundColor: Colors.red,  // Red color to signify emergency
    );
  }

  void _makePhoneCall_() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber('9840893080');
    if (res != null) {
      // Call initiated successfully
      print('Call initiated successfully');
    } else {
      // Call initiation failed
      print('Call initiation failed');
    }
  }

  void _makePhoneCall() async {
    final dbHelper = DatabaseHelper.instance;

    // Retrieve emergency contacts from the database
    List<String> contacts = await dbHelper.getEmergencyContacts();

    if (contacts.isNotEmpty) {
      // Select the first contact number for the call
      String phoneNumber = contacts[0];

      // Make the phone call
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);

      if (res != null) {
        // Call initiated successfully
        print('Call initiated successfully');
      } else {
        // Call initiation failed
        print('Call initiation failed');
      }
    } else {
      print('No emergency contacts found');
    }
  }


  void _sendLocationViaWhatsApp() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // Permission granted, proceed to get location and send message
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String locationMessage = 'Emergency! I need help. Here is my current location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      String phoneNumber = '9840893080'; // Replace with your emergency contact's number
      String whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeFull(locationMessage)}";

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } else {
      // Handle location permission denied
      print("Location permission denied");
    }
  }
}
