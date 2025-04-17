import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';

class Viewall extends StatelessWidget {
  const Viewall({super.key});

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
                const Align(alignment: Alignment.centerLeft,child: Text('Trending',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w500),)),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                      'assets/images/albumcover.jpg')),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.black45),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'STAY',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Justine Bieber',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        Icon(
                                          CupertinoIcons.play_circle_fill,
                                          color: appTextColor,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                const Align(alignment: Alignment.centerLeft,child: Text('Pop',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w500),)),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                      'assets/images/albumcover.jpg')),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.black45),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'STAY',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Justine Bieber',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        Icon(
                                          CupertinoIcons.play_circle_fill,
                                          color: appTextColor,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                const Align(alignment: Alignment.centerLeft,child: Text('Romantic',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w500),)),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                      'assets/images/albumcover.jpg')),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.black45),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'STAY',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Justine Bieber',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        Icon(
                                          CupertinoIcons.play_circle_fill,
                                          color: appTextColor,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                const Align(alignment: Alignment.centerLeft,child: Text('Feel Good',style: TextStyle(fontFamily: appFont ,color: appTextColor,fontSize: 25,fontWeight: FontWeight.w500),)),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                      'assets/images/albumcover.jpg')),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 70,
                                  decoration:
                                      const BoxDecoration(color: Colors.black45),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'STAY',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Justine Bieber',
                                              style: TextStyle(
                                                  fontFamily: appFont,
                                                  color: appTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                        Icon(
                                          CupertinoIcons.play_circle_fill,
                                          color: appTextColor,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
