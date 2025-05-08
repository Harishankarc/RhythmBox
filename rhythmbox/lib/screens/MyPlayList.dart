import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rhythmbox/components/appbutton.dart';
import 'package:rhythmbox/screens/nowPlayingLocally.dart';
import 'package:rhythmbox/screens/nowplaying.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlayList extends StatefulWidget {
  const MyPlayList({super.key});

  @override
  State<MyPlayList> createState() => _MyPlayListState();
}

class _MyPlayListState extends State<MyPlayList> {
  late final _currentUser;
  bool isPlaylist = true;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  void initState() {
    super.initState();
    _currentUser = Supabase.instance.client.auth.currentUser;
    checkAndRequestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        radius: 30,
                        child: _currentUser?.userMetadata?['avatar_url'] != null
                            ? Image.network(
                                "${_currentUser?.userMetadata?['avatar_url']}",
                                scale: 0.1,
                              )
                            : Image.asset('assets/images/profile.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Your Library",
                      style: TextStyle(color: appTextColor, fontSize: 30),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    AppButton(
                      text: "Playlist",
                      onPressed: () {
                        setState(() {
                          isPlaylist = true;
                        });
                      },
                      width: 100,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AppButton(
                      text: "Local Storage",
                      onPressed: () {
                        setState(() {
                          isPlaylist = false;
                        });
                      },
                      width: 150,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (isPlaylist == true)
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appBackground,
                          border: Border.all(width: 0.1, color: Colors.white)),
                      child: ListTile(
                        leading:
                            // Image.memory(
                            //   song['album'] as Uint8List,
                            //   width: 50,
                            //   height: 50,
                            //   fit: BoxFit.cover,
                            // ),
                            Image.asset(
                          'assets/images/profile.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          'Sample',
                          style: const TextStyle(
                              color: appTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Sample',
                          style: const TextStyle(
                              color: appTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                else if (_hasPermission)
                  FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                        sortType: null,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (context, item) {
                        if (item.hasError) {
                          return Text(item.error.toString());
                        }
                        if (item.data == null) {
                          return const CircularProgressIndicator();
                        }
                        if (item.data!.isEmpty) {
                          return const Text("Nothing found!");
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: item.data!.length,
                          itemBuilder: (context, index) {
                            final song = item.data![index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: appBackground,
                                  border: Border.all(
                                      width: 0.1, color: Colors.white)),
                              child: GestureDetector(
                                onTap: () async {
                                  print(song.data);
                                  final artwork = await _audioQuery.queryArtwork(
                                    song.id,
                                    ArtworkType.AUDIO,
                                  );
                                  print(artwork);
                                   Get.to(
                                      () => NowPlayingLocally(
                                            song_path: song.data,
                                            song_name: song.title,
                                            song_artist: song.artist,
                                            song_photo_mem: artwork,
                                            song_photo_file: _currentUser?.userMetadata?['avatar_url'],
                                          ),
                                      transition: Transition.downToUp,
                                      duration:
                                          const Duration(milliseconds: 300));
                                },
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    controller: _audioQuery,
                                    id: song.id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: Image.asset(
                                        'assets/images/profile.jpg',
                                        width: 50,
                                        height: 50),
                                  ),
                                  title: Text(
                                    song.title,
                                    style: const TextStyle(
                                        color: appTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    song.artist ?? 'Unknown Artist',
                                    style: const TextStyle(
                                        color: appTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })
                      else
                        const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
