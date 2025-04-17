import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/constants.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10,),
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
                    const Text('Good Evening Harishankar !',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w500),),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        radius: 60,
                        child: Image.asset('assets/images/profile.jpg'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("hari",style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 35,fontWeight: FontWeight.w600),),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(decoration: const BoxDecoration(color: buttonOverlay),child: const Text(' 999 Followers ',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 15,fontWeight: FontWeight.w500),)),
                            const SizedBox(width: 5,),
                            Container(decoration: const BoxDecoration(color: buttonOverlay),child: const Text(' 999 Following ',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 15,fontWeight: FontWeight.w500),)),

                          ],
                        ),
                        const SizedBox(height: 10,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Free Account',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 18,fontWeight: FontWeight.w600),),
                            SizedBox(width: 10,),
                            Text('Upgrade',style: TextStyle(fontFamily: appFont ,color: appTextColor4,fontSize: 18,fontWeight: FontWeight.w600),),
                          ],
                        )
                      ],
                    ),
                    
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: (){},style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(buttonOverlay),
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                    ), child: const Text('Edit Profile',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 20,fontWeight: FontWeight.w600),),),
                    TextButton(onPressed: (){},style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(buttonOverlay),
                      padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                    ), child: const Text('Share Profile',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 20,fontWeight: FontWeight.w600),),),
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  // height: 320,
                  decoration: BoxDecoration(
                    color: buttonOverlay,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft,child: Text('Jump back in',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w600),)),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('assets/images/albumcover2.jpg',width: 150,)),
                                          const SizedBox(height: 10,),
                                          const Text('Morgan Maxwell',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 20,fontWeight: FontWeight.w500),),
                                                                  
                                        ],
                                      ),
                                    ),
                                  ),
                                
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20,),
                Container(
                  // height: 320,
                  decoration: BoxDecoration(
                    color: buttonOverlay,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Align(alignment: Alignment.centerLeft,child: Text('Favorate',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w600),)),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('assets/images/albumcover2.jpg',width: 150,)),
                                          const SizedBox(height: 10,),
                                          const Text('Morgan Maxwell',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 20,fontWeight: FontWeight.w500),),
                                                                  
                                        ],
                                      ),
                                    ),
                                  ),
                                
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}