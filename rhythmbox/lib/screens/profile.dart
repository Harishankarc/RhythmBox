import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rhythmbox/auth/Authentication.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:rhythmbox/components/inputbox.dart';
import 'package:rhythmbox/screens/nowplaying.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/conectivityservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Authentication auth = new Authentication();
  Conectivityservice _conectivityservice = Conectivityservice();
  final Apifromdb data = Apifromdb();
  final upgradeContoller1 = TextEditingController();
  final upgradeContoller2 = TextEditingController();
  final upgradeContoller3 = TextEditingController();
  final upgradeContoller4 = TextEditingController();
  var isShown = false;
  List<Map<String, dynamic>> likedMusic = [];
  List<Map<String, dynamic>> recentlyPlayedMusic = [];
  late final _currentUser;
  late double widthInput;

  void _showUpgradeModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(208, 35, 36, 41),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 16,
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(208, 35, 36, 41),

              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  child: Icon(Icons.arrow_back_ios_new,size: 20,color: Colors.white,))),
                Text(
                  'Upgrade Your Plan',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                      color: appTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Get access to all features of Rhythmbox',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                      color: appTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputBox(controller: upgradeContoller1, width: widthInput, textalign: true,),
                    InputBox(controller: upgradeContoller2, width: widthInput, textalign: true,),
                    InputBox(controller: upgradeContoller3, width: widthInput, textalign: true,),
                    InputBox(controller: upgradeContoller4, width: widthInput, textalign: true,),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final enteredvalue = upgradeContoller1.text + upgradeContoller2.text + upgradeContoller3.text + upgradeContoller4.text;
                    if (enteredvalue == '1234') {
                      try{
                        final response = await Supabase.instance.client.auth.updateUser(
                          UserAttributes(
                            data: {
                              'ispremium' : true
                            }
                          )
                        );
                        if(response.user != null && response.user!.userMetadata != null && response.user!.userMetadata!['ispremium'] == true){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You have successfully upgraded your plan"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          setState(() {
                            _currentUser = Supabase.instance.client.auth.currentUser;
                          });
                          Navigator.of(context).pop();
                        }

                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("An error occurred: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Incorrect passcode!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(appBackground),
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  child: const Text(
                    'Upgrade Now',
                    style: TextStyle(
                        color: appTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getLikedMusicAndRecentlyPlayed() async{
    await Future.wait([
      data.getLikedSongs(_currentUser?.email),
      data.getRecentlyPlayedMusic(_currentUser?.email)
    ]).then((results)=>{
      setState(() {
        likedMusic = results[0];
      }),
      setState(() {
        recentlyPlayedMusic = results[1];
      })
    });
  }

  @override
  void initState() {
    super.initState();
    _conectivityservice.checkInternet(context);
    _currentUser = Supabase.instance.client.auth.currentUser;
    getLikedMusicAndRecentlyPlayed();
  }

  @override
  Widget build(BuildContext context) {
    widthInput = (MediaQuery.of(context).size.width - 140) /4;
    return Scaffold(
      backgroundColor: appBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: appTextColor, width: 0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: appTextColor,
                            ),
                          ),
                          Text(
                            'Good Evening ${_currentUser?.userMetadata?['name']} !',
                            style: TextStyle(
                                color: appTextColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 60,
                              child: _currentUser
                                          ?.userMetadata?['avatar_url'] !=
                                      null
                                  ? Image.network(
                                      "${_currentUser?.userMetadata?['avatar_url']}",
                                      scale: 0.1,
                                    )
                                  : Image.asset('assets/images/profile.jpg'),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_currentUser?.userMetadata?['name']}",
                                style: TextStyle(
                                    color: appTextColor,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      child: const Text(
                                        ' 999 Followers ',
                                        style: TextStyle(
                                            color: appTextColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      child: const Text(
                                        ' 999 Following ',
                                        style: TextStyle(
                                            color: appTextColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _currentUser?.userMetadata['ispremium'] ==
                                            true
                                        ? 'Premium Account'
                                        : 'Free Account',
                                    style: TextStyle(
                                        color: _currentUser?.userMetadata[
                                                    'ispremium'] ==
                                                true
                                            ? Colors.yellowAccent
                                            : appTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _currentUser?.userMetadata['ispremium'] == true
                                  ? null
                                  : _showUpgradeModal(context);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    const WidgetStatePropertyAll(buttonOverlay),
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: Text(
                              _currentUser?.userMetadata['ispremium'] == true
                                  ? 'Upgraded'
                                  : 'Upgrade Now',
                              style: TextStyle(
                                  color: appBackground,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      "This feature is not available yet!"),
                                  backgroundColor: Colors.red,
                                  elevation: 20 * 4.0,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    const WidgetStatePropertyAll(buttonOverlay),
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: const Text(
                              'Share Profile',
                              style: TextStyle(
                                  color: appBackground,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          TextButton(
                            onPressed: () async {
                              final response = await auth.logOutUser();
                              if (response == 200) {
                                await Get.to(() => const Login(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 500));
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    const WidgetStatePropertyAll(buttonOverlay),
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                  color: appBackground,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  // height: 320,
                  decoration: BoxDecoration(
                      color: appBackground,
                      border: Border.all(color: appTextColor,width: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Liked',
                              style: TextStyle(
                                  color: appTextColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                          height: 220,
                          child: likedMusic.isNotEmpty ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: likedMusic.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final song = likedMusic[index];
                              return GestureDetector(
                                onTap: () async {
                                  Get.to(() => NowPlaying(
                                                  song_id: song['id'],
                                                  user_id: _currentUser?.email,
                                                ),
                                            transition: Transition.downToUp,
                                            duration: const Duration(
                                                milliseconds: 300));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 25),
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.memory(
                                                            song['album']
                                                                as Uint8List,
                                                                width: 150,
                                                                height: 150,
                                                                fit: BoxFit.cover,
                                                          ),
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${song['title']}',
                                              style: TextStyle(
                                                  color: appTextColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ) : Center(
                                    child: LoadingAnimationWidget.hexagonDots(
                                        color: appTextColor, size: 50))
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  // height: 320,
                  decoration: BoxDecoration(
                      color: appBackground,
                      border: Border.all(color: appTextColor, width: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Recently Played',
                              style: TextStyle(
                                  color: appTextColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                          height: 220,
                          child: recentlyPlayedMusic.isNotEmpty ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: recentlyPlayedMusic.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final song = recentlyPlayedMusic[index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.memory(
                                                            song['album']
                                                                as Uint8List,
                                                                width: 150,
                                                                height: 150,
                                                                fit: BoxFit.cover,
                                                          ),),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${song['title']}',
                                            style: TextStyle(
                                                color: appTextColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ) : Center(
                                    child: LoadingAnimationWidget.hexagonDots(
                                        color: appTextColor, size: 50))
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
