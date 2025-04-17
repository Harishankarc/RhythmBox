import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  List<dynamic> data = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> fetchData() async {
    var url = Uri.parse("http://10.0.2.2:4000/songs");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body); // Expecting an array of objects
        });
      } else {
        print("Error fetching data: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _playAudio(String base64Audio) async {
    if (base64Audio.isNotEmpty) {
      try {
        final decodedBytes = base64Decode(base64Audio);
        // Check if the audio player is initialized and ready
        _audioPlayer.onPlayerStateChanged.listen((playerState) {
          print("Audio Player State: $playerState");
        });
        await _audioPlayer.play(BytesSource(decodedBytes));
        print("Audio is playing");
      } catch (e) {
        print("Error playing audio: $e");
      }
      } else {
        print("No audio to play");
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var song = data[index];
                var title = song['title'] ?? 'Unknown Title';
                var artist = song['artist'] ?? 'Unknown Artist';
                var audio = song['audio'] ?? ''; // Base64 audio string
                var image = song['image'] ?? ''; // Base64 image string

                return Card(
                  child: Column(
                    children: [
                      Text('Title: $title'),
                      Text('Artist: $artist'),
                      image.isNotEmpty
                          ? Image.memory(
                              base64Decode(image),
                              height: 200,
                              width: 200,
                            )
                          : const Text('No Image Available'),
                      ElevatedButton(
                        onPressed: () => _playAudio(audio),
                        child: const Text('Play Audio'),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
