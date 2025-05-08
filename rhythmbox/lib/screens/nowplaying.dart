import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as aj;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/constants.dart';

class NowPlaying extends StatefulWidget {
  final int song_id;
  final String user_id;

  const NowPlaying({super.key, required this.song_id, required this.user_id});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final aj.AudioPlayer player = aj.AudioPlayer();
  final Apifromdb data = Apifromdb();
  bool isLoading = true;

  Map<String, dynamic>? songdata;
  bool isLiked = false;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadSongData();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _loadSongData() async {
    try {
      final result = await data.getSongs();
      final current =
          result.firstWhere((e) => e['id'] == widget.song_id, orElse: () => {});
      if (current.isEmpty) return;

      setState(() => songdata = current);
      isLiked = (await data.checkIfLiked(widget.song_id, widget.user_id)) == 1;
      await data.addOrUpdateRecentlyPlayedMusic(widget.user_id, widget.song_id);
      await _initializePlayer();
    } catch (e) {
      print("Error loading song data: $e");
    }
  }

  Future<void> _initializePlayer() async {
    try {
      final source = aj.AudioSource.uri(Uri.parse(songdata!['song']));
      await player.setAudioSource(source);
      await player.load();

      player.durationStream
          .listen((d) => setState(() => _duration = d ?? Duration.zero));
      player.positionStream.listen((p) => setState(() => _position = p));
      player.playerStateStream.listen((state) {
        setState(() => isPlaying = state.playing);
        if (state.processingState == aj.ProcessingState.completed) {
          setState(() => _position = _duration);
          Future.delayed(
              const Duration(seconds: 1), () => Navigator.pop(context));
        }
      });

      setState(() => isPlaying = true);
      setState(() => isLoading = false);
      await player.play();
    } catch (e) {
      print("Player error: $e");
    }
  }

  Future<void> _togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    setState(() => isPlaying = player.playing);
  }

  Future<void> _toggleLike() async {
    final status = await data.likeSong(widget.song_id, widget.user_id);
    if (status == 200) {
      setState(() => isLiked = !isLiked);
    }
  }
Widget loadSplashScreen(){
    return Scaffold(
      backgroundColor: appBackground,
      body: Center(
                    child: LoadingAnimationWidget.hexagonDots(
                        color: appTextColor, size: 50)
      ),
    );
  }
  Widget _buildBackground() {
    if (songdata?['album'] == null) {
      return Center(
        child:
            LoadingAnimationWidget.hexagonDots(color: appTextColor, size: 60),
      );
    }
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Image.memory(
        songdata!['album'],
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _buildContent() {
    if (songdata == null) {
      return Center(
        child:
            LoadingAnimationWidget.hexagonDots(color: appTextColor, size: 60),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(songdata!['title'].toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: appTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )),
            const SizedBox(height: 6),
            Text(songdata!['artist'],
                style: const TextStyle(
                     color: Colors.white70, fontSize: 18)),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                songdata!['album'],
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (v) => player.seek(Duration(seconds: v.toInt())),
              activeColor: Colors.white,
              inactiveColor: Colors.white38,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_position.toString().split('.').first,
                      style: const TextStyle(color: Colors.white)),
                  Text(_duration.toString().split('.').first,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.fast_rewind,
                      color: Colors.white, size: 35),
                  onPressed: () =>
                      player.seek(Duration(seconds: _position.inSeconds - 10)),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward,
                      color: Colors.white, size: 35),
                  onPressed: () =>
                      player.seek(Duration(seconds: _position.inSeconds + 10)),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text("This feature is not available yet!"),
                          backgroundColor: Colors.red,
                          elevation: 20 * 4.0,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                },child: const Icon(Icons.share, color: Colors.white)),
                GestureDetector(
                  onTap: _toggleLike,
                  child: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: appTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('NOW PLAYING',
            style: TextStyle(
              color: appTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? loadSplashScreen()
          : Stack(
        children: [
          _buildBackground(),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          SafeArea(child: _buildContent()),
        ],
      ),
    );
  }
}
