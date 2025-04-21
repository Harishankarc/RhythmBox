import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
class Apifromdb {

  //change this when not working ensure mobile and lap is on same network

  final String url = 'https://rhythmbox.sattva2025.site/songs';
  Future<List<Map<String, dynamic>>> getSongs() async {
    try{
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> songs = jsonDecode(response.body);
        print("Song length ${songs.length}" );
        return songs.map((song) {
        return {
          'id' : song['id'],
          'title': song['title'],
          'artist': song['artist'],
          'song': song['song'],
          'album': base64Decode(song['album']),
        };
      }).toList();
      } else {
        throw Exception('Failed to load songs');
      }
    }catch(e){
      print("Error fetching songs: $e");
      return [];
    }
  }
}