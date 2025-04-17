

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/screens/nowplaying.dart';
import '../utils/constants.dart';
import 'profile.dart';
import 'viewall.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: appBackground,
      body: GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx < 0){
            Get.to(()=>const Profile(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
          }
          if (details.delta.dx > 0){
            Get.to(()=>const NowPlaying(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child:  Padding(
              padding: const EdgeInsets.only(left: 20,right:20),
              child: Column(
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome',style: TextStyle(fontFamily: appFont ,color: Colors.white54,fontSize: 25,fontWeight: FontWeight.w400),),
                            Text('Find your best',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 35,fontWeight: FontWeight.w600),),
                            Text('good Music',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 35,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        GestureDetector(
                          onTap: ()async{ 
                                    await Get.to(()=>const Profile(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));},
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                                
                            ),
                            child: ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('assets/images/profile.jpg')),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: appTextColor),
                          cursorColor: appTextColor,
                          decoration: const InputDecoration(
                            fillColor: buttonOverlay,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: appTextColor
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: Colors.transparent
                              )
                            ),
                            prefixIcon: Icon(CupertinoIcons.search,color: appTextColor,size: 25,),
                            hintText: 'Search for title,artist,songs...',
                            hintStyle: TextStyle(fontFamily: appFont ,color: Colors.white54,fontSize: 15,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis)
                          ),
                        ),
                      ),
                      const Padding(
                        padding:  EdgeInsets.only(left: 20),
                        child:  Icon(Icons.filter_list,color: appTextColor,size: 35,),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Trending',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 20,fontWeight: FontWeight.w500),),
                      GestureDetector(
                        onTap: ()async {
                          await Get.to(()=>const Viewall(),transition: Transition.upToDown,duration: const Duration(milliseconds: 400));
                      },
                      child: const Text('View more',style: TextStyle(fontFamily: appFont ,color: Colors.deepOrangeAccent,fontSize: 18,fontWeight: FontWeight.w500),)),
            
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () async {
                              await Get.to(()=> const NowPlaying(), transition: Transition.downToUp,duration: const Duration(milliseconds: 300));
                            },
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset('assets/images/albumcover.jpg')),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.black45
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('STAY',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w600),),
                                                Text('Justine Bieber',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 15,fontWeight: FontWeight.w500),),
                                                SizedBox(height: 10,)
                                              ],
                                            ),
                                            Icon(CupertinoIcons.play_circle_fill,color: appTextColor,size: 35,)
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
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(alignment: Alignment.centerLeft,child: Text('Picked for you',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w600),)),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Get.to(()=> const NowPlaying(),transition: Transition.downToUp,duration: const Duration(milliseconds: 300));
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: buttonOverlay
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: Image.asset('assets/images/albumcover2.jpg'),
                                title: const Text('STARBOY',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize:18,fontWeight: FontWeight.w600),),
                                subtitle: const Text('Morgan Maxwell',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 15,fontWeight: FontWeight.w400),),
                                trailing: const Icon(Icons.play_circle_outlined,color: appTextColor,size: 35,),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
            
                ],
              ),
            ),
            ),
        ),
      ),
    );
  }
}