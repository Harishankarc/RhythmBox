import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rhythmbox/components/appbutton.dart';
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
  @override
  void initState() {
    super.initState();
    _currentUser = Supabase.instance.client.auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              children: [
                SizedBox(height: 20,),
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
                    SizedBox(width: 20,),
                    Text("Your Library",style: TextStyle(color: appTextColor,fontSize: 30),),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    AppButton(text: "Playlist", onPressed: (){
                      setState(() {
                        isPlaylist = true;
                      });
                    }, width: 100,),
                    SizedBox(
                      width: 10,
                    ),
                    AppButton(text: "Local Storage", onPressed: (){
                      setState(() {
                        isPlaylist = false;
                      });
                    }, width: 150,),
                  ],
                ),
                SizedBox(height: 20,),
                if(isPlaylist == true)
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
                        Image.asset('assets/images/profile.jpg',width: 50,height: 50,fit: BoxFit.cover,),
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
                else
                const Center(
                      child: CircularProgressIndicator(
                          color: appTextColor, strokeWidth: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}