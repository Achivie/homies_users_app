import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/screens/onboarding_screen.dart';

import '../styles.dart';
import 'auth_screen.dart';
import 'home_page.dart';

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({Key? key}) : super(key: key);

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _bookingTypeTabController;
  late TextEditingController _searchBookingTextController;
  int screenIndex = 0;

  @override
  void initState() {
    _bookingTypeTabController = TabController(length: 2, vsync: this);
    _searchBookingTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: true,
            backgroundColor: AppColors.mainColor,
            title: Text(
              "Your Bookings",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              decoration: BoxDecoration(
                color: AppColors.inactiveDotColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: TabBar(
                  onTap: ((index) {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      screenIndex = index;
                    });
                  }),
                  indicatorColor: AppColors.transparent,
                  enableFeedback: true,
                  splashBorderRadius: BorderRadius.circular(20),
                  splashFactory: NoSplash.splashFactory,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: AppColors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.activeButtonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: AppColors.white,
                  labelStyle: const TextStyle(
                    // color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: AppColors.inactiveTextColor,
                  controller: _bookingTypeTabController,
                  tabs: const [
                    CustomTabBarItems(
                      label: "Ongoing",
                    ),
                    CustomTabBarItems(
                      label: "Past",
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (screenIndex == 1)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                child: InputTextFormField(
                  controller: _searchBookingTextController,
                  textInputType: TextInputType.text,
                  hint: "Looking for bookings",
                  textInputAction: TextInputAction.search,
                  fillColor: AppColors.inactiveSliderColor,
                  contentPadding: EdgeInsets.only(left: 20),
                  suffix: IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.search,
                      color: AppColors.mainColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          if (screenIndex == 0)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(
                        context,
                        AppKeys.roomDetailsRouteKey,
                        arguments: "12345",
                      );
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                        top: 10,
                        bottom: 10,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inactiveSliderColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            height: double.infinity,
                            width: 81,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            imageUrl:
                                "https://images.pexels.com/photos/11509450/pexels-photo-11509450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Blue Vibe Room Blue Vibe Room",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ptSerif(
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "12:20 am on 12/12/2021",
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  vertical: 5,
                                  horizontal: 0,
                                  buttonColor: AppColors.secondaryText,
                                  textColor: AppColors.white,
                                  head: "Message",
                                  onTap: (() {}),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
          if (screenIndex == 1)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: (() {}),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                        top: 10,
                        bottom: 10,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inactiveSliderColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            height: double.infinity,
                            width: 81,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            imageUrl:
                                "https://images.pexels.com/photos/11509450/pexels-photo-11509450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Blue Vibe Room Blue Vibe Room",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ptSerif(
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "12:20 am on 12/12/2021",
                                    style: TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        vertical: 5,
                                        horizontal: 0,
                                        buttonColor: AppColors.inactiveDotColor,
                                        textColor: AppColors.activeButtonColor,
                                        head: "See Details",
                                        onTap: (() {}),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                        vertical: 5,
                                        horizontal: 0,
                                        buttonColor: AppColors.secondaryText,
                                        textColor: AppColors.white,
                                        head: "Review",
                                        onTap: (() {}),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
        ],
      ),
    );
  }
}
