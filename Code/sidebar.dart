import 'package:flutter/material.dart';
import 'fitness.dart';
import 'emergency.dart';
import 'recipe.dart';
import 'profile.dart';
import 'dbHelper.dart';
import 'progress.dart';
import 'proginput.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>?>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture =
        DatabaseHelper.instance.getFirstUserNameAndEmail(); // Load user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HealthSync'),
      ),
      body: HealthProgressPage(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  var user = snapshot.data!;
                  return UserAccountsDrawerHeader(
                    currentAccountPicture: const Icon(
                      Icons.account_circle_outlined,
                      size: 48.0,
                      color: Colors.white,
                    ),
                    accountName: Text(user['name'] ?? 'No Name'),
                    accountEmail: Text(user['email'] ?? 'No Email'),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9q7_yWTH8SG0wKWxPkjNeFEnb6kY9dyNANw&s'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2),
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const UserAccountsDrawerHeader(
                    accountName: Text('Loading...'),
                    accountEmail: Text(''),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('Profile'),
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(),
                    ),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.local_restaurant_rounded),
              title: Text('Recipe Guide'),
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => recipeGuide(),
                    ),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Fitness Advisor'),
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FitnessAdv(),
                    ),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('Health Tracker'),
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HealthTracker(),
                    ),
                  ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      floatingActionButton: EmergencyButton(),
    );
  }
}
