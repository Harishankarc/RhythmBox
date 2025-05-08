import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/components/appbutton.dart';
import 'package:rhythmbox/components/inputbox.dart';
import 'package:rhythmbox/utils/MainNavigation.dart';
import 'package:rhythmbox/utils/apifromdb.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  TextEditingController playlistcontroller = TextEditingController();
  Apifromdb api = Apifromdb();
  late final _currentUser;

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create your playlist a name",
                  style: TextStyle(color: appTextColor, fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80, top: 10),
                child: InputBox(
                    controller: playlistcontroller,
                    hintText: 'Playlist Name',
                    obscureText: false,
                    fillColor: Colors.transparent,
                    borderColor: Colors.white,
                    textalign: true,
                    textColor: Colors.white,
                    ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    text: "Create",
                    width: 200,
                    backgroundColor: buttonOverlay,
                    textColor: Colors.black,
                    onPressed: () {
                      if(playlistcontroller.text.isNotEmpty){
                        if(api.addPlayListName(
                                _currentUser?.email, playlistcontroller.text) == 200){
                          SnackBar snackBar = const SnackBar(
                            content: Text("Playlist Created"),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Get.offAll(() => MainNavigation());
                        };
                      }else{
                        SnackBar snackBar = const SnackBar(
                          content: Text("Enter a name"),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
