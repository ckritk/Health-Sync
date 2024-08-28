// main.dart
import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'editprofile.dart';
import 'emergency.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileWidget(),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}


class _ProfileWidgetState extends State<ProfileWidget> {
  Future<Map<String, dynamic>?> firstUserData = Future.value(null);

  @override
  void initState() {
    super.initState();
    firstUserData = DatabaseHelper.instance.getFirstUserData();
  }

  void _refreshUserData() {
    setState(() {
      firstUserData = DatabaseHelper.instance.getFirstUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => HealthSyncEditProfPage(),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.blue,
            onPressed: _refreshUserData,
          )
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: firstUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No user data found'));
          }
          var user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  user['name'] ?? 'No Name',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user['email'] ?? 'No Email',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.grey.shade800,
                    fontSize: 16,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(user['number1'] ?? 'No Number 1'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(user['number2'] ?? 'No Number 2'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(user['number3'] ?? 'No Number 3'),
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border_rounded),
                  title: Text(user['healthIssue'] ?? 'No Health Issue'),
                ),
                ListTile(
                  leading: Icon(Icons.person_rounded),
                  title: Text(user['gender'] ?? 'No Gender'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: EmergencyButton(),
    );
  }
}



