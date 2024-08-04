import 'package:flutter/material.dart';
import 'ytube.dart';
import 'emergency.dart';

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page One')),
      body: Center(child: Text('Welcome to Page One!')),
    );
  }
}

class NavigationCard extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Widget nextPage;
  final String image;  // URL of the background image

  NavigationCard({
    required this.name,
    required this.backgroundColor,
    required this.nextPage,
    required this.image, // Added parameter for image URL
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Adjust opacity here
              BlendMode.dstATop, // This blend mode applies the filter color on top of the image
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(FitnessAdv());
}

class FitnessAdv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Fitness Advisor')),
        body: Column(
          children: [
            NavigationCard(
              name: "Yoga",
              backgroundColor: Colors.lightBlue,
              nextPage: MultiVideoPlayerScreen( query : 'Yoga for diabetes'),
              image : 'https://img.freepik.com/premium-photo/woman-doing-yoga-beach-with-mountain-background_865967-25537.jpg',
            ),
            NavigationCard(
              name: "Workout",
              backgroundColor: Colors.blueAccent,
              nextPage: MultiVideoPlayerScreen( query : 'Exercise for diabetes'),
              image : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQM2yzE8kaqtF4ZOXBqa4hUmyo6M1C5UEKmWw&s',
            ),
            NavigationCard(
              name: "Wellness Coaching",
              backgroundColor: Colors.lightBlueAccent,
              nextPage: MultiVideoPlayerScreen( query : 'motivation diabetic patients'),
              image : 'https://granitemountainbhc.com/wp-content/uploads/2020/01/AdobeStock_222477248-scaled.jpeg',
            ),
          ],
        ),
        floatingActionButton: EmergencyButton(),
      ),
    );
  }
}


