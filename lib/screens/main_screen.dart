import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as GeoLocator;
import 'package:homies/screens/bookings_screen.dart';
import 'package:homies/screens/home_page.dart';
import 'package:homies/screens/message_page.dart';
import 'package:homies/screens/roommate_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.screen,
  }) : super(key: key);

  final int screen;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedHomeIndex = 0;
  late GeoLocator.LocationPermission permission;
  late GeoLocator.Position? userPosition;
  List<Placemark>? placemarks;
  late GeoLocator.LocationSettings locationSettings;

  @override
  void initState() {
    selectedHomeIndex = widget.screen;
    getLocationSettings();
    getLocation();
    super.initState();
  }

  Future<bool> checkLocationPermission() async {
    permission = await GeoLocator.Geolocator.checkPermission();
    if (permission == GeoLocator.LocationPermission.denied) {
      permission = await GeoLocator.Geolocator.requestPermission();
      if (permission == GeoLocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        openAppSettings();
      }
    }

    if (permission == GeoLocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    return true;
  }

  getLocation() async {
    if (await checkLocationPermission()) {
      userPosition = await GeoLocator.Geolocator.getCurrentPosition(
          desiredAccuracy: GeoLocator.LocationAccuracy.high);
      if (userPosition != null) {
        placemarks = await getLocationDetails(userPosition!);
      }

      GeoLocator.Geolocator.getPositionStream(
              locationSettings: locationSettings)
          .listen((GeoLocator.Position? position) async {
        if (position != null) {
          userPosition = position;
          placemarks = await getLocationDetails(userPosition!);
          setState(() {});
        }
      });
    } else {
      log("No Permission");
    }
  }

  getLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = GeoLocator.AndroidSettings(
        accuracy: GeoLocator.LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        foregroundNotificationConfig:
            const GeoLocator.ForegroundNotificationConfig(
          notificationText:
              "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = GeoLocator.AppleSettings(
        accuracy: GeoLocator.LocationAccuracy.high,
        activityType: GeoLocator.ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = GeoLocator.LocationSettings(
        accuracy: GeoLocator.LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  Future<List<Placemark>> getLocationDetails(
          GeoLocator.Position position) async =>
      await placemarkFromCoordinates(
        userPosition!.latitude,
        userPosition!.longitude,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedHomeIndex == 1
          ? AppBar(
              centerTitle: true,
              backgroundColor: AppColors.mainColor,
              leading: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Hero(
                  tag:
                      "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, AppKeys.profileRouteKey);
                    }),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                          "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg"),
                    ),
                  ),
                ),
              ),
              title: const Text(
                "Roommates",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: (() {}),
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                  ),
                ),
              ],
            )
          : null,
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: (() {
                selectedHomeIndex = 0;
                setState(() {});
              }),
              icon: BottomNavBarIcon(
                icon: (selectedHomeIndex == 0)
                    ? CupertinoIcons.house_alt_fill
                    : CupertinoIcons.home,
                size: (selectedHomeIndex == 0) ? 25 : 20,
              ),
            ),
            IconButton(
              onPressed: (() {
                selectedHomeIndex = 1;
                setState(() {});
              }),
              icon: BottomNavBarIcon(
                icon: (selectedHomeIndex == 1)
                    ? CupertinoIcons.group_solid
                    : CupertinoIcons.group,
                size: (selectedHomeIndex == 1) ? 30 : 25,
              ),
            ),
            IconButton(
              onPressed: (() {
                selectedHomeIndex = 2;
                setState(() {});
              }),
              icon: BottomNavBarIcon(
                icon: (selectedHomeIndex == 2)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: (selectedHomeIndex == 2) ? 25 : 20,
              ),
            ),
            IconButton(
              onPressed: (() {
                selectedHomeIndex = 3;
                setState(() {});
              }),
              icon: BottomNavBarIcon(
                icon: (selectedHomeIndex == 3)
                    ? CupertinoIcons.bag_fill
                    : CupertinoIcons.bag,
                size: (selectedHomeIndex == 3) ? 25 : 20,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      body: Builder(builder: (ctx) {
        switch (selectedHomeIndex) {
          case 0:
            return HomePage(placemarks: placemarks);
          case 1:
            return RoommatePage();
          case 2:
            return MessagePage();
          case 3:
            return AllBookingsScreen();
          default:
            return HomePage();
        }
      }),
    );
  }
}

class BottomNavBarIcon extends StatelessWidget {
  const BottomNavBarIcon({
    super.key,
    required this.icon,
    this.size,
  });

  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: AppColors.white,
      size: size,
    );
  }
}
