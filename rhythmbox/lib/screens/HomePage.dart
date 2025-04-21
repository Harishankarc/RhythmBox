import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:rhythmbox/screens/nowplaying.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/conectivityservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/constants.dart';
import 'profile.dart';
import 'viewall.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Conectivityservice _conectivityservice = Conectivityservice();
  final TextEditingController _searchController = TextEditingController();
  final Apifromdb data = Apifromdb();
  late final _currentUser;

  List<Map<String, dynamic>>? songdata;
  List<Map<String, dynamic>> suggestionSong = [];

  @override
  void initState() {
    super.initState();
    _conectivityservice.checkInternet(context);
    _currentUser = Supabase.instance.client.auth.currentUser;
    checkSession();
    getSongsFromDb();
  }

  void checkSession() async {
    final currentuser = Supabase.instance.client.auth.currentUser;
    if (currentuser == null) {
      await Get.to(() => const Login(),
          transition: Transition.cupertino,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> getSongsFromDb() async {
    final result = await data.getSongs();
    setState(() {
      songdata = result;
    });
  }

  Future<void> _handleRefresh() async {
    await getSongsFromDb();
  }

  List<Map<String, dynamic>> showCurrentTypedMusic(String value) {
    final filteredSongs = songdata?.where((song) {
      final title = song['title']?.toLowerCase() ?? '';
      return title.contains(value.toLowerCase());
    }).toList();

    return filteredSongs ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx.abs() > details.delta.dy.abs()) {
            if (details.delta.dx < 0) {
              Get.to(() => const Profile(),
                  transition: Transition.cupertino,
                  duration: const Duration(milliseconds: 500));
            }
          }
        },
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: appBackground3,
          displacement: 100,
          backgroundColor: Colors.black,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  fontFamily: appFont,
                                  color: Colors.white54,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Find your best',
                              style: TextStyle(
                                  fontFamily: appFont,
                                  color: appTextColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'good Music',
                              style: TextStyle(
                                  fontFamily: appFont,
                                  color: appTextColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Profile(),
                                transition: Transition.cupertino,
                                duration:
                                    const Duration(milliseconds: 500));
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _currentUser
                                            ?.userMetadata?['avatar_url'] !=
                                        null &&
                                    _currentUser
                                        ?.userMetadata?['avatar_url']
                                        .toString()
                                        .isNotEmpty ==
                                        true
                                ? NetworkImage(
                                        _currentUser.userMetadata['avatar_url'])
                                    as ImageProvider
                                : const AssetImage('assets/images/profile.jpg'),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          suggestionSong = showCurrentTypedMusic(value);
                        });
                      },
                      style: const TextStyle(color: appTextColor),
                      cursorColor: appTextColor,
                      decoration: const InputDecoration(
                          fillColor: buttonOverlay,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: appTextColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.transparent)),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: appTextColor,
                            size: 25,
                          ),
                          hintText: 'Search for title, artist, songs...',
                          hintStyle: TextStyle(
                              fontFamily: appFont,
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.w400)),
                    ),
                    const SizedBox(height:5),
                    if (_searchController.text.isNotEmpty &&
                        suggestionSong.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestionSong.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestionSong[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom:5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),color: Colors.grey[800],
                            ),
                            child: ListTile(
                              leading: Image.memory(
                                  suggestion['album'] as Uint8List,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              title: Text(
                                suggestion['title'] ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                suggestion['artist'] ?? "",
                                style: const TextStyle(color: Colors.white54),
                              ),
                              trailing: Transform.rotate(
                                angle: 4,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: appBackground3,
                                ),
                              ),
                              onTap: () {
                                Get.to(() => NowPlaying(id: suggestion['id']));
                              },
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trending',
                          style: TextStyle(
                              fontFamily: appFont,
                              color: appTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Viewall(),
                                transition: Transition.upToDown,
                                duration:
                                    const Duration(milliseconds: 400));
                          },
                          child: const Text(
                            'View more',
                            style: TextStyle(
                                fontFamily: appFont,
                                color: Colors.deepOrangeAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (songdata != null && songdata!.isNotEmpty)
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: songdata!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final song = songdata![index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => NowPlaying(id: song['id']),
                                    transition: Transition.downToUp,
                                    duration:
                                        const Duration(milliseconds: 300));
                              },
                              child: Container(
                                width: 200,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        song['album'] as Uint8List,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song['title'] ?? '',
                                              style: const TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              song['artist'] ?? '',
                                              style: const TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Center(
                          child: CircularProgressIndicator(
                              color: appTextColor, strokeWidth: 2)),
                    const SizedBox(height: 30),
                    const Text(
                      'Picked for you',
                      style: TextStyle(
                          fontFamily: appFont,
                          color: appTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    if (songdata != null && songdata!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: songdata!.length,
                        itemBuilder: (context, index) {
                          final song = songdata![index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => NowPlaying(id: song['id']),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 300));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: buttonOverlay),
                              child: ListTile(
                                leading: Image.memory(
                                  song['album'] as Uint8List,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  song['title'] ?? '',
                                  style: const TextStyle(
                                      fontFamily: appFont,
                                      color: appTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  song['artist'] ?? '',
                                  style: const TextStyle(
                                      fontFamily: appFont,
                                      color: appTextColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                trailing: const Icon(
                                  Icons.play_circle_outlined,
                                  color: appTextColor,
                                  size: 35,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      const Center(
                          child: CircularProgressIndicator(
                              color: appTextColor, strokeWidth: 2)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
