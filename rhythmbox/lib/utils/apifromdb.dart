import 'dart:convert';

import 'package:http/http.dart' as http;
class Apifromdb {

  //change this when not working ensure mobile and lap is on same network

  Future<List<Map<String, dynamic>>> getSongs() async {
    try{
      final response = await http.get(Uri.parse('https://rhythmbox.sattva2025.site/songs'));
      if (response.statusCode == 200) {
        final List<dynamic> songs = jsonDecode(response.body);
        return songs.map((song) {
        return {
          'id' : song['id'],
          'title': song['title'],
          'genere': song['genere'],
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
  Future<int> checkIfLiked(int song_id, String user_id) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://rhythmbox.sattva2025.site/isliked'),
        body: {
          'song_id': song_id.toString(),
          'user_id': user_id,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['liked'] ? "liked the music" : "not liked the music");
        return data['liked'] ? 1 : 0;
      } else {
        return -1;
      }
    } catch (e) {
      print("Error checking liked song: $e");
      return -1;
    }
  }

  Future<int> likeSong(int song_id,String user_id) async{

    try{
      final response = await http.post(Uri.parse('https://rhythmbox.sattva2025.site/like'),headers: {"Content-Type": "application/json"},body: jsonEncode({
        'song_id' : song_id,
        'user_id' : user_id
      }));
      if(response.statusCode == 200){
        print("Tiggered liked song functon gives 200");
        print(response.body);
        return 200;
      }else{
        print("Triggered liked song functon give 500");
        print(response.body);
        return 500;
      }
    }catch(e){
      print("Error adding song: $e");
      return 500;
    }
  }
  Future<List<Map<String, dynamic>>> getLikedSongs(String user_id) async{
    try{
      final response = await http.post(Uri.parse("https://rhythmbox.sattva2025.site/getLikedSongs"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"user_id":user_id}));
      if(response.statusCode == 200){
        final List<dynamic> songs = jsonDecode(response.body);
        return songs.map((song) {
          return {
            'id': song['id'],
            'title': song['title'],
            'album': base64Decode(song['album']),
          };
        }).toList();
      }else{
        throw Exception('Failed to load songs');
      }
    }catch(e){
      print("Error Fetching liked music : ${e}");
      return [];
    }
  }
  Future<int> addOrUpdateRecentlyPlayedMusic(String user_id,int song_id) async{
    try{
      final response = await http.post(Uri.parse("https://rhythmbox.sattva2025.site/recentSong"),
      headers: {
        'Content-Type': 'application/json',
      }
      ,body: jsonEncode({
        'user_id' : user_id,
        'song_id' : song_id
      }));
      if(response.statusCode == 200){
        print("recently played song body : ${response.body}");
        return 200;
      }else{
        print("recently played song body : ${response.body}");
        return 500;
      }
    }catch(e){
      print("Error Fetching liked music : ${e}");
      return 400;
    }
  }
  Future<List<Map<String, dynamic>>> getRecentlyPlayedMusic(String user_id) async{
    try{
      final response = await http.post(Uri.parse("https://rhythmbox.sattva2025.site/getRecentlyPlayedSongs"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"user_id": user_id}));
      if(response.statusCode == 200){
        final List<dynamic> songs = jsonDecode(response.body);
        return songs.map((song) {
          return {
            'id': song['id'],
            'title': song['title'],
            'album': base64Decode(song['album']),
          };
        }).toList();
      }else{
        throw Exception('Failed to load recently played songs');
      }
    }catch(e){
      print("Error Fetching recently played music : ${e}");
      return [];
    }
  }
  Future<int> addPlayListName(String user_id,String playlistName) async{
    try{
      final response = await http.post(Uri.parse("https://rhythmbox.sattva2025.site/playlistname"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"user_id": user_id, "playlistName": playlistName}));
      if(response.statusCode == 200){
        print("Playlist name added");
        return 200;
      }else{
        print("Playlist name not added");
        return 500;
      }
    }catch(e){
      print("Error Fetching recently played music : ${e}");
      return 500;
    }
  }


}