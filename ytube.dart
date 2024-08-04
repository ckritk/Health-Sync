import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import 'emergency.dart';

Future<List<String>> fetchYouTubeVideos(String query) async {
  final apiKey = 'AIzaSyD5w_9IGW4Cxvu2Hk9HIUInsrcxTyYDmB4';
  final String apiUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&maxResults=3&key=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<String> videoLinks = [];
    for (var item in data['items']) {
      String videoId = item['id']['videoId'];
      videoLinks.add('$videoId');
    }
    return videoLinks;
  } else {
    throw Exception('Failed to load videos');
  }
}

class MultiVideoPlayerScreen extends StatefulWidget {
  final String query;

  MultiVideoPlayerScreen({Key? key, required this.query}) : super(key: key);

  @override
  _MultiVideoPlayerScreenState createState() => _MultiVideoPlayerScreenState();
}

class _MultiVideoPlayerScreenState extends State<MultiVideoPlayerScreen> {
  late Future<List<YoutubePlayerController>> _futureControllers;

  Future<List<YoutubePlayerController>> fetchAndSetupControllers(String query) async {
    final videoIds = await fetchYouTubeVideos(query);
    return videoIds.map((videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,  // Set to true for a better experience on web
        autoPlay: false,  // Prevent videos from automatically playing
        startAt: Duration(seconds: 0), // Start at the beginning of the video
      ),
    )).toList();
  }


  @override
  void initState() {
    super.initState();
    _futureControllers = fetchAndSetupControllers(widget.query);
  }

  @override
  void dispose() {
    _futureControllers.then((controllers) {
      for (var controller in controllers) {
        controller.close();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggested Videos'),
      ),
      body: FutureBuilder<List<YoutubePlayerController>>(
        future: _futureControllers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            // Return the ListView with padding and border around each video.
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),  // Add padding around each video
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),  // Blue border around the video
                      borderRadius: BorderRadius.circular(10),  // Rounded corners
                    ),
                    child: ClipRRect(  // Clip it to have rounded corners
                      borderRadius: BorderRadius.circular(10),
                      child: YoutubePlayerIFrame(
                        controller: snapshot.data![index],
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: EmergencyButton(),
    );
  }

}