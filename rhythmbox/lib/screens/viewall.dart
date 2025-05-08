import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rhythmbox/screens/nowplaying.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Viewall extends StatefulWidget {
  const Viewall({super.key});

  @override
  State<Viewall> createState() => _ViewallState();
}

class _ViewallState extends State<Viewall> {
  final Apifromdb api = Apifromdb();
  List<Map<String, dynamic>>? trendingSongs;
  List<Map<String, dynamic>>? popSongs;
  List<Map<String, dynamic>>? romanticSongs;
  List<Map<String, dynamic>>? feelGoodSongs;
  late final _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Supabase.instance.client.auth.currentUser;
    getSongData();
  }

  Future<void> getSongData() async {
    final data = await api.getSongs();
    setState(() {
      trendingSongs = data.where((song) {
        final genre = song['genere']?.toString().toLowerCase();
        return genre == 'trending';
      }).toList();
      popSongs = data.where((song) {
        final genre = song['genere']?.toString().toLowerCase();
        return genre == 'pop';
      }).toList();
      romanticSongs = data.where((song) {
        final genre = song['genere']?.toString().toLowerCase();
        return genre == 'romantic';
      }).toList();
      feelGoodSongs = data.where((song) {
        final genre = song['genere']?.toString().toLowerCase();
        return genre == 'feelgood';
      }).toList();
    });
  }

  Widget songSection(String title, List<Map<String, dynamic>>? songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: appTextColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 170,
          child: songs != null && songs.isNotEmpty
              ? ListView.builder(
                  itemCount: songs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return GestureDetector(
                      onTap: () async{
                        await Get.to(() => NowPlaying(song_id: song['id'],user_id: _currentUser?.email,),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 300));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: song['album'] != null
                                    ? Image.memory(song['album'] as Uint8List,
                                        fit: BoxFit.cover,
                                        height: 170,
                                        width: 170)
                                    : Image.asset('assets/images/albumcover.jpg',
                                        fit: BoxFit.cover,
                                        height: 170,
                                        width: 170),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${song['title']}',
                                              style: const TextStyle(
                                                color: appTextColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${song['artist']}',
                                              style: const TextStyle(
                                                color: appTextColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          CupertinoIcons.play_circle_fill,
                                          color: appTextColor,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                    child: LoadingAnimationWidget.hexagonDots(
                        color: appTextColor, size: 50))
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                songSection('Trending', trendingSongs),
                songSection('Pop', popSongs),
                songSection('Romantic', romanticSongs),
                songSection('Feel Good', feelGoodSongs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
