import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/screens/home_page.dart';
import 'package:homies/screens/onboarding_screen.dart';
import 'package:homies/screens/search_screen.dart';
import 'package:homies/styles.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:price_converter/price_converter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/chip_data_model.dart';
import 'auth_screen.dart';
import 'booking_screen.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  int selectedRating = 0, selectedPage = 0, currImage = 0;
  double _rating = 1.0;
  late NumberPaginatorController numberPaginatorController;
  late CarouselController carouselController;
  late TextEditingController _commentsTextController;
  Position? position;
  bool isActiveBooking = false;

  Future<String> getData() {
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
      // throw Exception("Custom Error");
    });
  }

  Future<void> openMapsDirections(
      double destinationLat, double destinationLong) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$destinationLat,$destinationLong';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openMap({
    required double latitude,
    required double longitude,
    required String label,
  }) async {
    final query = '$latitude,$longitude($label)';
    final uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});

    await launchUrl(uri);
  }

  Future<void> getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {});

      // print('Current Location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  void initState() {
    numberPaginatorController = NumberPaginatorController();
    _commentsTextController = TextEditingController();
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: isActiveBooking
          ? Container(
              height: 65,
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.inactiveTextColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(
                          context,
                          AppKeys.bookingRouteKey,
                          arguments: widget.uid,
                        );
                      }),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.activeButtonColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Book now",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 65,
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                // color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      horizontal: 0,
                      vertical: 0,
                      buttonColor: AppColors.activeButtonColor,
                      textColor: AppColors.white,
                      head: "Chat with host",
                      topMargin: 10,
                      bottomMargin: 10,
                      onTap: (() {}),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      horizontal: 0,
                      vertical: 0,
                      topMargin: 10,
                      bottomMargin: 10,
                      buttonColor: AppColors.inactiveDotColor,
                      textColor: AppColors.inactiveTextColor,
                      head: "Cancel Booking",
                      onTap: (() {}),
                    ),
                  ),
                ],
              ),
            ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: AppColors.mainColor,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
              ),
            ),
            title: Text(
              "Room",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            expandedHeight: 580,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              stretchModes: const <StretchMode>[],
              background: ClipRRect(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  margin: EdgeInsets.only(
                    top: 95,
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: 420.0,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1.2,
                            enlargeFactor: 0.2,
                            scrollPhysics: AppConstants.scrollPhysics,
                            onPageChanged: ((currImage, reason) {
                              this.currImage = currImage;
                              setState(() {});
                            }),
                          ),
                          items: [1, 2, 3, 4, 5].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          margin: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        imageUrl:
                                            "https://images.pexels.com/photos/11509450/pexels-photo-11509450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        margin: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 25,
                                          right: 15,
                                          bottom: 25,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors.transparent,
                                              AppColors.transparent,
                                              AppColors.mainColor
                                                  .withOpacity(0.8),
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Service Room",
                                              style: GoogleFonts.ptSerif(
                                                textStyle: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                        color: AppColors.white,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "\$12.50/1 hour",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: (() {
                                                      Navigator.pushNamed(
                                                        context,
                                                        AppKeys
                                                            .imagePreviewRouteKey,
                                                        arguments:
                                                            "https://images.pexels.com/photos/11509450/pexels-photo-11509450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                                      );
                                                    }),
                                                    icon: Icon(
                                                      Icons.fullscreen_rounded,
                                                      color: AppColors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: currImage,
                        count: 5,
                        effect: SwapEffect(
                          dotHeight: 7,
                          dotWidth: 7,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.inactiveTextColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: Text(
                                    "23 Sun View Rd, Little Town, CA, 234 2423 Sun View Rd, Little Town, CA, 23424",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: (() async {
                                await getCurrentLocation();
                                await openMap(
                                  latitude: position!.latitude,
                                  longitude: position!.longitude,
                                  label: widget.uid,
                                );
                              }),
                              icon: Icon(
                                CupertinoIcons.compass,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          children: [
                            DetailWidget(
                              icon: Icons.bed,
                              count: 1.toString(),
                              iconColor: AppColors.inactiveTextColor,
                              textColor: AppColors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DetailWidget(
                              icon: Icons.bathtub_outlined,
                              count: 1.toString(),
                              iconColor: AppColors.inactiveTextColor,
                              textColor: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: 10,
              ),
              child: Text(
                "Booking Details",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 5,
              ),
              child: Column(
                children: [
                  BookingDetailsRow(
                    item: 'Price',
                    price:
                        "${PriceConverter.getFormattedPrice(currency: "₹", price: 10000)}/-",
                  ),
                  BookingDetailsRow(
                    item: 'Booking Period',
                    price: "2 months",
                  ),
                  BookingDetailsRow(
                    item: 'Person',
                    price: 2.toString(),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                    ),
                  ),
                  BookingDetailsRow(
                    item: 'Total Amount',
                    itemTextColor: AppColors.mainColor,
                    price: 10000.toString(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: 10,
              ),
              child: Text(
                "Description",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 10,
              ),
              child: Text(
                "Our fancy room with minimalism decoration will make you feel like home! We have an area for cooking and a cafe shop at ground floor. 24/7 security with our guards at front door will make you feel safe all the time.",
                style: TextStyle(
                  fontSize: 14,
                  height: 2,
                  fontWeight: FontWeight.w400,
                ),
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
              child: Text(
                "Facilities",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
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
            child: Container(
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(234)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  RatingContainer(
                    align: 1,
                    text: "4.5",
                    horizontalPadding: 15,
                    verticalPadding: 10,
                    icon: AppConstants.iconSelection(1),
                    iconColor: AppConstants.iconColorSelection(1),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputTextFormField(
                      controller: _commentsTextController,
                      textInputType: TextInputType.multiline,
                      hint: "Type Comment",
                      suffix: IconButton(
                        onPressed: (() {}),
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppColors.activeButtonColor,
                        ),
                      ),
                    ),
                  ),
                  Slider(
                    activeColor: AppColors.activeButtonColor,
                    inactiveColor: AppColors.inactiveDotColor,
                    secondaryActiveColor: AppColors.activeDotColor,
                    value: _rating,
                    label: _rating.toString(),
                    min: 1.0,
                    max: 5.0,
                    divisions:
                        8, // Adjust the number of divisions based on your needs
                    onChanged: (value) {
                      setState(() {
                        // Round the value to the nearest 0.5
                        _rating = (value * 2).round() / 2;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingContainer(
                        icon: AppConstants.iconSelection(1),
                        iconColor: AppConstants.iconColorSelection(1),
                        verticalPadding: 2,
                        horizontalPadding: 5,
                        containerColor: AppColors.inactiveSliderColor,
                        text: "1",
                        align: 0,
                      ),
                      RatingContainer(
                        icon: AppConstants.iconSelection(5),
                        iconColor: AppConstants.iconColorSelection(5),
                        verticalPadding: 2,
                        horizontalPadding: 5,
                        containerColor: AppColors.inactiveSliderColor,
                        text: "5",
                        align: 0,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (() {
                        selectedRating = 0;
                        setState(() {});
                      }),
                      child: RatingContainer(
                        align: 1,
                        text: "All",
                        horizontalPadding: 0,
                        verticalPadding: 10,
                        textColor: selectedRating == 0
                            ? AppColors.activeButtonColor
                            : AppColors.mainColor,
                        containerColor: selectedRating == 0
                            ? AppColors.inactiveDotColor
                            : AppColors.textFieldColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (() {
                        selectedRating = 1;
                        setState(() {});
                      }),
                      child: RatingContainer(
                        text: "4 to 5",
                        horizontalPadding: 15,
                        verticalPadding: 10,
                        icon: AppConstants.iconSelection(5),
                        iconColor: AppConstants.iconColorSelection(5),
                        textColor: selectedRating == 1
                            ? AppColors.activeButtonColor
                            : AppColors.mainColor,
                        containerColor: selectedRating == 1
                            ? AppColors.inactiveDotColor
                            : AppColors.textFieldColor,
                        align: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (() {
                        selectedRating = 2;
                        setState(() {});
                      }),
                      child: RatingContainer(
                        align: 1,
                        text: "1 to 3",
                        horizontalPadding: 15,
                        verticalPadding: 10,
                        icon: AppConstants.iconSelection(3),
                        iconColor: AppConstants.iconColorSelection(3),
                        textColor: selectedRating == 2
                            ? AppColors.activeButtonColor
                            : AppColors.mainColor,
                        containerColor: selectedRating == 2
                            ? AppColors.inactiveDotColor
                            : AppColors.textFieldColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: getData(),
            builder: (context, projectSnap) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      //color: AppColors.inactiveSliderColor,
                      margin: EdgeInsets.only(
                        left: 25,
                        right: 25,
                        bottom: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Lisa Monica",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  RatingContainer(
                                    align: 0,
                                    text: "4.5",
                                    horizontalPadding: 0,
                                    verticalPadding: 2,
                                    textColor: AppColors.mainColor,
                                    icon: AppConstants.iconSelection(3),
                                    iconColor:
                                        AppConstants.iconColorSelection(3),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: 15,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inactiveDotColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              "So in love with this room. My host is very friendly and helpful",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: 10,
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 10,
              ),
              child: NumberPaginator(
                controller: numberPaginatorController,
                numberPages: 10,
                config: NumberPaginatorUIConfig(
                  buttonSelectedForegroundColor: AppColors.mainColor,
                  buttonSelectedBackgroundColor: AppColors.inactiveSliderColor,
                ),
                prevButtonBuilder: ((prevBtnCtx) {
                  return Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: numberPaginatorController.currentPage == 0
                            ? AppColors.inactiveTextColor.withOpacity(0.6)
                            : AppColors.mainColor,
                      ),
                    ),
                    child: InkWell(
                      onTap: (() {
                        if (numberPaginatorController.currentPage != 0) {
                          numberPaginatorController.prev();
                        }
                      }),
                      child: Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_right_alt_rounded,
                          color: numberPaginatorController.currentPage == 0
                              ? AppColors.inactiveTextColor.withOpacity(0.6)
                              : AppColors.mainColor,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }),
                nextButtonBuilder: ((nextBtnCtx) {
                  return Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: numberPaginatorController.currentPage == 9
                            ? AppColors.inactiveTextColor.withOpacity(0.6)
                            : AppColors.mainColor,
                      ),
                    ),
                    child: InkWell(
                      onTap: (() {
                        if (numberPaginatorController.currentPage != 9) {
                          numberPaginatorController.next();
                        }
                      }),
                      child: Icon(
                        Icons.arrow_right_alt_rounded,
                        color: numberPaginatorController.currentPage == 9
                            ? AppColors.inactiveTextColor.withOpacity(0.6)
                            : AppColors.mainColor,
                        size: 20,
                      ),
                    ),
                  );
                }),
                onPageChange: (int currPage) {
                  selectedPage = currPage;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
