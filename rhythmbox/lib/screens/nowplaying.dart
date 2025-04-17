import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isPlaying = false;
  late final AudioPlayer player;
  late final AssetSource path;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> initPlayer() async {
    player = AudioPlayer();
    path = AssetSource('audios/StarBoy.mp3');

    player.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    player.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        _position = _duration;
        isPlaying = false;
      });
    });
  }

  Future<void> playPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(path);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
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
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Album',
                  style: TextStyle(
                    fontFamily: appFont,
                    color: appTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'STARBOY',
                  style: TextStyle(
                    fontFamily: appFont,
                    color: appTextColor,
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'Morgan Maxwell - 2011',
                  style: TextStyle(
                    fontFamily: appFont,
                    color: appTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  '11 Song List',
                  style: TextStyle(
                    fontFamily: appFont,
                    color: appTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appTextColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Title Song',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: appTextColor5,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'STARBOY',
                        style: TextStyle(
                          fontFamily: appFont,
                          color: appTextColor5,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 100,
                              child: Image.asset('assets/images/albumcover2.jpg'),
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
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            await player.seek(Duration(seconds: value.toInt()));
                          },
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          inactiveColor: appBackground,
                          activeColor: appBackground,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _position.toString().split('.').first,
                              style: const TextStyle(color: appTextColor5,fontFamily: appFont ,fontSize: 15,fontWeight: FontWeight.w700),
                            ),
                            Text(
                              _duration.toString().split('.').first,
                              style: const TextStyle(color: appTextColor5,fontFamily: appFont ,fontSize: 15,fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              await player.seek(Duration(seconds: _position.inSeconds - 10));
                            },
                            child: const Icon(Icons.fast_rewind, color: appBackground,size: 40,),
                          ),
                          InkWell(
                            onTap: playPause,
                            child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,  color: appBackground,size: 40,),
                          ),
                          InkWell(
                            onTap: () async {
                              await player.seek(Duration(seconds: _position.inSeconds + 10));
                            },
                            child: const Icon(Icons.fast_forward,  color: appBackground,size: 40,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
