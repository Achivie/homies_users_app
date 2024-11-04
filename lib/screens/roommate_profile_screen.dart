import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/roommate_model.dart';
import 'package:homies/screens/profile_pages.dart';
import 'package:homies/styles.dart';
import 'package:readmore/readmore.dart';

import '../models/chip_data_model.dart';

class RoommateProfileScreen extends StatefulWidget {
  const RoommateProfileScreen({
    Key? key,
    required this.roommateModel,
  }) : super(key: key);

  final RoommateModel roommateModel;

  @override
  State<RoommateProfileScreen> createState() => _RoommateProfileScreenState();
}

class _RoommateProfileScreenState extends State<RoommateProfileScreen> {
  List<String> otherPics = [];
  var top = 0.0;

  @override
  void initState() {
    otherPics.addAll(widget.roommateModel.otherPics);
    // otherPics.addAll(widget.roommateModel.otherPics);
    // otherPics.addAll(widget.roommateModel.otherPics);
    // otherPics.addAll(widget.roommateModel.otherPics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.mainColor,
            floating: true,
            pinned: true,
            centerTitle: false,
            leadingWidth: 60,
            leading: CustomIconButton(
              onTap: (() {
                Navigator.pop(context);
              }),
              icon: Icons.arrow_back_rounded,
              iconColor: AppColors.white,
            ),
            expandedHeight: 350,
            flexibleSpace: LayoutBuilder(
              builder: ((ctx, constraints) {
                top = constraints.biggest.height;

                return FlexibleSpaceBar(
                  centerTitle: false,
                  // title: (MediaQuery.of(context).padding.top + kToolbarHeight ==
                  //         top)
                  //     ? Text(
                  //         widget.roommateModel.name,
                  //         style: GoogleFonts.ptSerif(
                  //           fontWeight: FontWeight.bold,
                  //           color: AppColors.white,
                  //           fontSize: 20,
                  //         ),
                  //       )
                  //     : Container(
                  //         decoration: BoxDecoration(
                  //           color: AppColors.mainColor.withOpacity(0.5),
                  //         ),
                  //         child: Text(
                  //           widget.roommateModel.name,
                  //           style: GoogleFonts.ptSerif(
                  //             fontWeight: FontWeight.bold,
                  //             color: AppColors.white,
                  //             fontSize: 20,
                  //           ),
                  //         ),
                  //       ),
                  stretchModes: const <StretchMode>[],
                  background: GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, AppKeys.imagePreviewRouteKey,
                          arguments: widget.roommateModel.profile);
                    }),
                    child: Hero(
                      tag: widget.roommateModel.profile,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        imageUrl: widget.roommateModel.profile,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "widget.roommateModel.name",
                      style: GoogleFonts.ptSerif(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        onTap: (() {}),
                        icon: Icons.thumb_up_off_alt_rounded,
                        iconColor: AppColors.red,
                        containerColor: AppColors.transparent,
                      ),
                      CustomIconButton(
                        onTap: (() {}),
                        icon: Icons.message_rounded,
                        iconColor: AppColors.bottomNaviBarDark.withOpacity(0.5),
                        containerColor: AppColors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: CustomHeadingText(
              head: "About",
              textStyle: TextStyle(
                color: AppColors.mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ReadMoreText(
                'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                trimLines: 2,
                style: TextStyle(color: AppColors.mainColor),
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: ' Show less',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.activeButtonColor,
                ),
                lessStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: CustomHeadingText(
              head: "Interests",
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 15,
                bottom: 0,
              ),
              textStyle: TextStyle(
                color: AppColors.mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  ChipData(
                    label: "All",
                    key: 0,
                  ),
                  ChipData(
                    label: "Elevator",
                    icon: Icons.elevator_outlined,
                    key: 1,
                  ),
                  ChipData(
                    label: "Hot Water",
                    icon: Icons.water_drop_outlined,
                    key: 2,
                  ),
                  ChipData(
                    label: "Cooking Place",
                    icon: Icons.microwave,
                    key: 3,
                  ),
                  ChipData(
                    label: "Parking",
                    icon: Icons.directions_car_filled_outlined,
                    key: 4,
                  ),
                  ChipData(
                    label: "Cleaning Service",
                    icon: Icons.cleaning_services,
                    key: 5,
                  ),
                  ChipData(
                    label: "Nearby Stores",
                    icon: Icons.store_outlined,
                    key: 6,
                  ),
                ].map(
                  (chip) {
                    return Chip(
                      label: Text(chip.label),
                      backgroundColor: AppColors.inactiveDotColor,
                      side: BorderSide(
                        width: 0,
                        color: AppColors.transparent,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainColor,
                      ),
                      avatar: (chip.icon != null)
                          ? Icon(
                              chip.icon,
                              color: AppColors.hintTextColor,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverAppBar(
            toolbarHeight: 10,
            leading: Container(),
            backgroundColor: AppColors.inactiveDotColor,
            pinned: true,
            flexibleSpace: Center(
              child: CustomHeadingText(
                padding: EdgeInsets.only(),
                head: "Gallery",
                textStyle: TextStyle(
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) {
                return GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(
                      context,
                      AppKeys.imagePreviewRouteKey,
                      arguments: otherPics[idx],
                    );
                  }),
                  child: Hero(
                    tag: otherPics[idx],
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            otherPics[idx],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: otherPics.length,
            ),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    this.containerColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor ?? AppColors.mainColor.withOpacity(0.3),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
