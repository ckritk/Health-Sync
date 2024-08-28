import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'emergency.dart';

class RecipeService {
  final String appId = 'ae3dab85';
  final String appKey = 'c8e6b8aa80aa216eb644e6b893fa7dea	';
  final List<String> searchTerms = ['diabetic-friendly', 'low sugar', 'high fiber diabetic'];

  Future<List<Map<String, dynamic>>> getRecipes_() async {
    List<Map<String, dynamic>> recipes = [];
    String query = searchTerms[Random().nextInt(searchTerms.length)];
    var uri = Uri.parse('https://api.edamam.com/search').replace(queryParameters: {
      'q': query,
      'app_id': appId,
      'app_key': appKey,
      'health': 'sugar-conscious',
      'from': '0',
      'to': '3'
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          for (var hit in data['hits']) {
            recipes.add(hit['recipe']);
          }
        }
      }
    } catch (e) {
      print('Failed to load recipes: $e');
    }
    return recipes;
  }

  Future<List<Map<String, dynamic>>> getRecipes1(String query) async {
    List<Map<String, dynamic>> recipes = [];
    var uri = Uri.parse('https://api.edamam.com/search').replace(queryParameters: {
      'q': query,
      'app_id': appId,
      'app_key': appKey,
      'health': 'diabetes-friendly',
      'from': '0',
      'to': '3'
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          for (var hit in data['hits']) {
            recipes.add(hit['recipe']);
          }
        }
      } else {
        print('Error loading recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load recipes: $e');
    }
    return recipes;
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    List<Map<String, dynamic>> recipes = [];
    var uri = Uri.parse('https://api.edamam.com/search').replace(queryParameters: {
      'app_id': appId,
      'app_key': appKey,
      'calories': 'gte 100, lte 300', // Example range for calories
      'nutrients[SUGAR]': '0-5', // Example range for sugar content (in grams)
      'health': 'sugar-conscious', // Additional filter for sugar-conscious recipes
      'from': '0',
      'to': '3'
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          for (var hit in data['hits']) {
            recipes.add(hit['recipe']);
          }
        }
      } else {
        print('Error loading recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load recipes: $e');
    }
    return recipes;
  }
  Future<List<Map<String, dynamic>>> getRecipes1_(String query) async {
    List<Map<String, dynamic>> recipes = [];
    var uri = Uri.parse('https://api.edamam.com/search').replace(queryParameters: {
      'app_id': appId,
      'app_key': appKey,
      'calories': 'gte 100, lte 300', // Example range for calories
      'nutrients[SUGAR]': '0-5', // Example range for sugar content (in grams)
      'health': 'sugar-conscious', // Additional filter for sugar-conscious recipes
      'from': '0',
      'to': '3'
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['hits'] != null && data['hits'].isNotEmpty) {
          for (var hit in data['hits']) {
            recipes.add(hit['recipe']);
          }
        }
      } else {
        print('Error loading recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load recipes: $e');
    }
    return recipes;
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeCard({required this.recipe});

  void _launchURL(BuildContext context, Uri? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid URL'))
      );
      return;
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the recipe.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Uri? recipeUri;
    try {
      recipeUri = Uri.parse(recipe['url']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid URL'))
      );
      return Container(); // Return an empty container if the URL is invalid.
    }

    return Card(
      margin: EdgeInsets.all(0), // Remove margin around the card
      clipBehavior: Clip.antiAlias, // Add this to respect the border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0), // Uniform rounded corners
      ),
      child: Row(
        children: [
          if (recipe['image'] != null)
            Image.network(
              recipe['image'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: <Widget>[
                  Text(
                    recipe['label'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Calories: ${recipe['calories'].round()} kcal',
                  ),
                  Text(
                    'Time: ${recipe['totalTime'] ?? 'N/A'} min',
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      child: Text('View Recipe'),
                      onPressed: () => _launchURL(context, recipeUri),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


void main() => runApp(recipeGuide());

class recipeGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetic Recipe Finder',
      home: RecipeSearchPage(),
    );
  }
}

class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final RecipeService _recipeService = RecipeService();
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  final TextEditingController _controller = TextEditingController();

  void fetchRecipes() async {
    List<Map<String, dynamic>> fetchedRecipes;
    if (_controller.text.isNotEmpty) {
      // If there is a search query, use it to fetch recipes
      fetchedRecipes = await _recipeService.getRecipes1(_controller.text);
    } else {
      // If the text field is empty, fetch default recipes
      fetchedRecipes = await _recipeService.getRecipes();
    }
    setState(() {
      recipes = fetchedRecipes;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Guide'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: recipes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: recipes[index]);
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: fetchRecipes,
              child: Text('Refresh Recipes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: EmergencyButton(),
    );
  }
}



