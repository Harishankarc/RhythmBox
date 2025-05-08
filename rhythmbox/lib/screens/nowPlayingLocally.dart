import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as aj;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/constants.dart';

class NowPlayingLocally extends StatefulWidget {
  final String? song_path;
  final String? song_name;
  final String? song_artist;
  final Uint8List? song_photo_mem;
  final String? song_photo_file;

  const NowPlayingLocally({super.key,  this.song_path, this.song_name, this.song_artist, this.song_photo_mem, this.song_photo_file});

  @override
  State<NowPlayingLocally> createState() => _NowPlayingLocallyState();
}

class _NowPlayingLocallyState extends State<NowPlayingLocally> {
  final aj.AudioPlayer player = aj.AudioPlayer();
  bool isLoading = true;
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
    await _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final source = aj.AudioSource.uri(Uri.parse('file://${widget.song_path}'));
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
      setState(() => isLoading = false);
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


  Widget loadSplashScreen() {
    return Scaffold(
      backgroundColor: appBackground,
      body: Center(
          child: LoadingAnimationWidget.hexagonDots(
              color: appTextColor, size: 50)),
    );
  }

  Widget _buildBackground() {
    if(widget.song_photo_mem != null){
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Image.memory(
            widget.song_photo_mem!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
      );
    }else{
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Image.network(
          widget.song_photo_file!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }

  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.song_name!.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: appTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                )),
            const SizedBox(height: 6),
            Text(widget.song_artist!,
                style: const TextStyle(color: Colors.white70, fontSize: 18)),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.song_photo_mem != null ? Image.memory(
                widget.song_photo_mem!,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ) : Image.network(
                widget.song_photo_file!,
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
                SafeArea(
                  child: _buildContent(),
                )
              ],
            ),
    );
  }
}
