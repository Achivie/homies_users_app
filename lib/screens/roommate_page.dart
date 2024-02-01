import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/styles.dart';

import '../constants.dart';
import '../models/roommate_model.dart';

class RoommatePage extends StatefulWidget {
  const RoommatePage({Key? key}) : super(key: key);

  @override
  State<RoommatePage> createState() => _RoommatePageState();
}

class _RoommatePageState extends State<RoommatePage> {
  late AppinioSwiperController appinioSwiperController;
  List<RoommateModel> roommates = [
    RoommateModel(
      name: 'Profile1',
      work: 'Work1',
      id: '1',
      age: 20,
      profile:
          'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile2',
      work: 'Work2',
      id: '2',
      age: 18,
      profile:
          'https://images.pexels.com/photos/3792581/pexels-photo-3792581.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile3',
      work: 'Work3',
      id: '3',
      age: 25,
      profile:
          'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile4',
      work: 'Work4',
      id: '4',
      age: 20,
      profile:
          'https://images.pexels.com/photos/34534/people-peoples-homeless-male.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile5',
      work: 'Work5',
      id: '5',
      age: 19,
      profile:
          'https://images.pexels.com/photos/1615776/pexels-photo-1615776.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile6',
      work: 'Work6',
      id: '6',
      age: 19,
      profile:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
    RoommateModel(
      name: 'Profile7',
      work: 'Work7',
      id: '7',
      age: 19,
      profile:
          'https://images.pexels.com/photos/17652903/pexels-photo-17652903/free-photo-of-naomi.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      otherPics: [
        "https://images.pexels.com/photos/1559486/pexels-photo-1559486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/678783/pexels-photo-678783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/1080213/pexels-photo-1080213.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      ],
    ),
  ];
  List<RoommateModel> roommatesHistory = [];
  int lastDeletedIdx = 0;

  @override
  void initState() {
    appinioSwiperController = AppinioSwiperController();
    super.initState();
  }

  void addRoommates() {
    roommates.addAll(roommates.reversed);
    lastDeletedIdx = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: AppinioSwiper(
        controller: appinioSwiperController,
        backgroundCardCount: 1,
        swipeOptions: const SwipeOptions.only(left: true, right: true),
        onEnd: addRoommates,
        onSwipeBegin: ((int idx1, int idx2, SwiperActivity swipeActivity) {}),
        onSwipeEnd: ((int idx1, int idx2, SwiperActivity swipeActivity) {
          // log(swipeActivity.currentOffset.dx.toString());
          if (swipeActivity.currentOffset.dx < 0) {
            log("Delete");
          } else if (swipeActivity.currentOffset.dx > 0) {
            log("Liked");
          }

          // roommates.add(roommates[idx1]);

          // log(appinioSwiperController.cardIndex.toString());

          // roommatesHistory.insert(roommatesHistory.length, roommates[idx1]);
          // roommates.removeAt(idx1 - 1);
          // log(roommatesHistory.length.toString());
          // setState(() {
          //   lastDeletedIdx = appinioSwiperController.cardIndex!;
          // });
        }),
        cardBuilder: (BuildContext ctx, int index) {
          return GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, AppKeys.roommateProfileRouteKey,
                  arguments: roommates[index]);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (ctx) => ProfilePage(),
              //   ),
              // );
            }),
            child: Stack(
              children: [
                Hero(
                  tag: roommates[index].profile,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          roommates[index].profile,
                        ),
                      ),
                      color: AppColors.inactiveDotColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.transparent,
                        AppColors.mainColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${roommates[index].name}, ${roommates[index].age}",
                        style: GoogleFonts.ptSerif(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        roommates[index].work,
                        style: GoogleFonts.ptSerif(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((othersCtx, othersIdx) {
                            if (othersIdx <=
                                roommates[index].otherPics.length - 1) {
                              return Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      roommates[index].otherPics[othersIdx],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 60,
                                width: 60,
                                child: Center(
                                  child: IconButton(
                                    onPressed: (() {}),
                                    icon: Icon(
                                      Icons.info,
                                      color: AppColors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                          separatorBuilder: ((sepCtx, sepIdx) =>
                              SizedBox(width: 5)),
                          itemCount: roommates[index].otherPics.length + 1,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        cardCount: roommates.length,
      ),
    );
  }
}
