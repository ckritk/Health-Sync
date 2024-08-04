import 'package:flutter/material.dart';
import 'dbhelper1.dart';
import 'emergency.dart';

void main() {
  runApp(HealthTracker());
}

class HealthTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalorieTracker(),
    );
  }
}

class CalorieTracker extends StatefulWidget {
  @override
  _CalorieTrackerState createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();

  double _totalCalories = 0;
  String _bpStatus = '';
  String _sugarStatus = '';

  void _calculateCalories() {
    // Calculate calories based on duration of exercise
    const double caloriesPerMinute = 7.5;
    int duration = int.tryParse(_durationController.text) ?? 0;
    double exerciseCalories = duration * caloriesPerMinute;

    // Add calories from food items
    double foodCalories = double.tryParse(_calorieController.text) ?? 0;

    setState(() {
      _totalCalories = exerciseCalories + foodCalories;
    });

    // Check BP status
    double bp = double.tryParse(_bpController.text) ?? 0;
    if (bp < 90 || bp > 120) {
      _bpStatus = 'High BP';
    } else if (bp < 90) {
      _bpStatus = 'Low BP';
    } else {
      _bpStatus = 'Normal BP';
    }

    // Check sugar status
    double sugar = double.tryParse(_sugarController.text) ?? 0;
    if (sugar < 70 || sugar > 130) {
      _sugarStatus = 'High Sugar';
    } else if (sugar < 70) {
      _sugarStatus = 'Low Sugar';
    } else {
      _sugarStatus = 'Normal Sugar';
    }

    // Insert record into database
    _insertHealthRecord();
  }

  Future<void> _insertHealthRecord() async {
    // Get current date
    String date = DateTime.now().toString();

    // Prepare record
    Map<String, dynamic> record = {
      'date': date,
      'duration': int.tryParse(_durationController.text) ?? 0,
      'caloriesBurned': _totalCalories,
      'bpStatus': _bpStatus,
      'sugarStatus': _sugarStatus,
      'sleephour': int.tryParse(_foodController.text) ?? 0,
    };

    // Insert record into database
    await _dbHelper.insertHealthRecord(record);
    print('Record inserted: $record'); // Print inserted record
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Exercise Duration (minutes)',
                hintText: 'Enter duration in minutes.',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories from Food',
                hintText: 'Enter calories from food',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _foodController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sleep Duration',
                hintText: 'Enter sleep duration',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _bpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Blood Pressure (mmHg)',
                hintText: 'Enter blood pressure',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _sugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Blood Sugar Level (mg/dL)',
                hintText: 'Enter blood sugar level',
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _calculateCalories,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Calories: $_totalCalories kcal',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'Blood Pressure Status: $_bpStatus',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Blood Sugar Status: $_sugarStatus',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: EmergencyButton(),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _foodController.dispose();
    _calorieController.dispose();
    _bpController.dispose();
    _sugarController.dispose();
    super.dispose();
  }
}


