import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:permission_handler/permission_handler.dart';
import 'dbhelper.dart';
class EmergencyButton extends StatefulWidget {
  @override
  _EmergencyButtonState createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  int _pressCounter = 0;
  String? _emergencyContactNumber;

  @override
  void initState() {
    super.initState();
    _fetchEmergencyContactNumber();
  }

  Future<void> _fetchEmergencyContactNumber() async {
    List<String> emergencyContacts = await DatabaseHelper.instance.getEmergencyContacts();
    setState(() {
      _emergencyContactNumber = emergencyContacts.isNotEmpty ? emergencyContacts.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        _pressCounter++;
        if (_pressCounter == 2) {
          List<String> emergencyContacts = await DatabaseHelper.instance.getEmergencyContacts();
          if (emergencyContacts.isNotEmpty) {
            for (String contactNumber in emergencyContacts) {
              bool callSuccessful = await _makePhoneCall(contactNumber);
              if (callSuccessful) {
                // Call successful, break the loop
                _sendLocationViaWhatsApp(contactNumber);
                break;
              }
            }
          }
          _pressCounter = 0; // Reset counter after calls initiated
        }
      },

      child: Text('Emergency Call'),
    );
  }

  Future<bool> _makePhoneCall(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res != null) {
      // Call initiated successfully
      print('Call initiated successfully');
      return true;
    } else {
      // Call initiation failed
      print('Call initiation failed');
      return false;
    }
  }


  void _sendLocationViaWhatsApp(String phoneNumber) async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // Permission granted, proceed to get location and send message
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String locationMessage =
          'Emergency! I need help. Here is my current location: https://www.google.com/maps/search/?api=1&query=${position
          .latitude},${position.longitude}';

      String whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$Uri.parse{(locationMessage)}";

      if (await url_launcher.canLaunchUrl(Uri.parse(whatsappUrl))) {
        await url_launcher.launchUrl(Uri.parse(whatsappUrl));
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    }
  }
}
