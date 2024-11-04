import 'package:flutter/material.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/chat_model.dart';
import 'package:homies/models/roommate_model.dart';
import 'package:homies/screens/auth_screen.dart';
import 'package:homies/screens/booking_screen.dart';
import 'package:homies/screens/chat_screen.dart';
import 'package:homies/screens/image_preview_screen.dart';
import 'package:homies/screens/main_screen.dart';
import 'package:homies/screens/onboarding_screen.dart';
import 'package:homies/screens/profile_pages.dart';
import 'package:homies/screens/profile_screen.dart';
import 'package:homies/screens/room_details_screen.dart';
import 'package:homies/screens/roommate_profile_screen.dart';
import 'package:homies/screens/search_screen.dart';
import 'package:homies/screens/splash_screen.dart';

import '../screens/route_error_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppKeys.initialRouteKey:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppKeys.onboardRouteKey:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingScreen(),
        );

      case AppKeys.authRouteKey:
        {
          final mode = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => AuthScreen(signMode: mode),
          );
        }

      case AppKeys.mainScreenRouteKey:
        {
          final screen = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => MainScreen(screen: screen),
          );
        }

      case AppKeys.searchRouteKey:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      case AppKeys.roomDetailsRouteKey:
        {
          final uid = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RoomDetailsScreen(
              roomID: uid,
            ),
          );
        }

      case AppKeys.chatScreenRouteKey:
        {
          final ChatScreenNavigateModel chatInitDetails =
              settings.arguments as ChatScreenNavigateModel;
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              chatScreenNavigateModel: chatInitDetails,
            ),
          );
        }

      case AppKeys.imagePreviewRouteKey:
        {
          final String url = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ImagePreviewScreen(
              url: url,
            ),
          );
        }

      case AppKeys.bookingRouteKey:
        {
          final uid = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => BookingScreen(
              uid: uid,
            ),
          );
        }

      case AppKeys.profileRouteKey:
        {
          return MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          );
        }

      case AppKeys.profilePagesRouteKey:
        {
          final route = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ProfilePages(route: route),
          );
        }

      case AppKeys.roommateProfileRouteKey:
        {
          final roommate = settings.arguments as RoommateModel;
          return MaterialPageRoute(
            builder: (_) => RoommateProfileScreen(roommateModel: roommate),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => const RouteErrorScreen(),
        );
    }
  }
}
