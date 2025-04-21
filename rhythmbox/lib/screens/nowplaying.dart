import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:just_audio/just_audio.dart' as aj;

class NowPlaying extends StatefulWidget {
  final int id;
  const NowPlaying({super.key, required this.id});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isPlaying = false;
  late final aj.AudioPlayer player;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  Apifromdb data = Apifromdb();
  Map<String, dynamic>? songdata;

  Future<void> getSongsFromDb() async {
    final result = await data.getSongs();
    final currentSong = result.firstWhere(
      (song) => song['id'] == widget.id,
      orElse: () => {},
    );

    if (currentSong.isEmpty) {
      print("Song not found.");
      return;
    }

    setState(() {
      songdata = currentSong;
    });

    await initPlayer();
  }

  @override
  void initState() {
    super.initState();
    player = aj.AudioPlayer();
    setState(() {
        isPlaying = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      getSongsFromDb();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> initPlayer() async {
    try {
      final String songUrl = songdata!['song']; 
      print("Song URL: $songUrl");

      final source = aj.AudioSource.uri(Uri.parse(songUrl));
      await player.setAudioSource(source);
      await player.play();

      player.durationStream.listen((Duration? d) {
        setState(() {
          _duration = d ?? Duration.zero;
        });
      });

      player.positionStream.listen((Duration p) {
        setState(() {
          _position = p;
        });
      });

      player.playerStateStream.listen((state) {
        setState(() {
          isPlaying = state.playing;
        });

        if (state.processingState == aj.ProcessingState.completed) {
          setState(() {
            _position = _duration;
          });
          Future.delayed(const Duration(seconds: 1),(){
            Navigator.of(context).pop();
          });
        }
      });
    } catch (e) {
      print("Error initializing player: $e");
    }
  }

  Future<void> playPause() async {
    try {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    setState(() {
      isPlaying = player.playing;
    });
  } catch (e) {
    print("Error toggling play/pause: $e");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: appTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: appBackground,
        title: const Text(
          'NOW PLAYING',
          style: TextStyle(
            fontFamily: appFont,
            color: appTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: songdata != null ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: appTextColor,
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: songdata?['album'] != null
                        ? MemoryImage(songdata!['album'] as Uint8List) 
                        : AssetImage('assets/images/albumcover.jpg') as ImageProvider, 
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.7), 
                        BlendMode.darken, 
                      ),
                    ),
                    
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${songdata?['title'].toUpperCase()}',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: appTextColor,
                          letterSpacing: 1,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${songdata?['artist']}',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: appTextColor,
                          letterSpacing: 1,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 100,
                              child: songdata?['album'] != null
                                  ? Image.memory(songdata!['album'],width: 200,height: 200,fit: BoxFit.cover,)
                                  : Image.asset('assets/images/albumcover.jpg'),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: appBackground3,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: appTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            await player.seek(Duration(seconds: value.toInt()));
                          },
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _position.toString().split('.').first,
                              style: const TextStyle(
                                color: appTextColor,
                                fontFamily: appFont,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _duration.toString().split('.').first,
                              style: const TextStyle(
                                color: appTextColor,
                                fontFamily: appFont,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              await player.seek(Duration(seconds: _position.inSeconds - 10));
                            },
                            child: const Icon(
                              Icons.fast_rewind,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          InkWell(
                            onTap: playPause,
                            child: Icon(
                              isPlaying ? Icons.pause_circle_rounded : Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await player.seek(Duration(seconds: _position.inSeconds + 10));
                            },
                            child: const Icon(
                              Icons.fast_forward,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ) : const Center(child: CircularProgressIndicator(
            color: appBackground3,
          ),),
        ),
      ),
    );
  }
}
