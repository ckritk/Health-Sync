import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dbHelper.dart';
import 'emergency.dart';

class HealthSyncEditProfPage extends StatefulWidget {
  const HealthSyncEditProfPage({Key? key}) : super(key: key);

  @override
  _HealthSyncEditProfPageState createState() => _HealthSyncEditProfPageState();
}

class _HealthSyncEditProfPageState extends State<HealthSyncEditProfPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  final TextEditingController _number3Controller = TextEditingController();
  String? _selectedHealthIssue;
  String? _selectedGender;

  bool isNewUser = true;  // To determine if we are adding or editing

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    var userData = await DatabaseHelper.instance.getFirstUserData();
    if (userData != null) {
      isNewUser = false;  // Set to false because user data exists
      _nameController.text = userData['name'];
      _emailController.text = userData['email'];
      _number1Controller.text = userData['number1'];
      _number2Controller.text = userData['number2'];
      _number3Controller.text = userData['number3'];
      _selectedHealthIssue = userData['healthIssue'];
      _selectedGender = userData['gender'];
      setState(() {});  // Refresh the UI with loaded data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthSync SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _number1Controller,
                decoration: InputDecoration(labelText: 'Number 1'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Number 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _number2Controller,
                decoration: InputDecoration(labelText: 'Number 2'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Number 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _number3Controller,
                decoration: InputDecoration(labelText: 'Number 3'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Number 3';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedHealthIssue,
                onChanged: (value) {
                  setState(() {
                    _selectedHealthIssue = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Type 2 Diabetic'),
                    value: 'Type 2 Diabetic',
                  ),
                  // Add more health issues as needed
                ],
                decoration: InputDecoration(labelText: 'Health Issue'),
              ),
              ListTile(
                title: Text('Male'),
                leading: Radio(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Female'),
                leading: Radio(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: EmergencyButton(),
    );
  }

  void _submitForm() async {
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'number1': _number1Controller.text,
      'number2': _number2Controller.text,
      'number3': _number3Controller.text,
      'gender': _selectedGender!,
      'healthIssue': _selectedHealthIssue!,
    };

    try {
      final db = DatabaseHelper.instance;
      int result;
      if (isNewUser) {
        result = await db.addUser(userData);  // Add new user
      } else {
        result = await db.editFirstRow(userData);  // Update existing user
      }
      print('Operation successful, result: $result');
    } catch (e) {
      print('Error while saving user data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _number1Controller.dispose();
    _number2Controller.dispose();
    _number3Controller.dispose();
    super.dispose();
  }
}




void main() {
  runApp(MaterialApp(
    home: HealthSyncEditProfPage(),
  ));
}



