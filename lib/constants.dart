import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:homies/styles.dart';
import 'package:phonenumbers_core/core.dart';

class AppKeys {
  static const String profileImage =
      "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg";
  static const String initialRouteKey = "/";
  static const String onboardRouteKey = "/on-board";
  static const String authRouteKey = "/auth";
  static const String imagePreviewRouteKey = "/image-preview";
  static const String bookingRouteKey = "/booking";
  static const String profileRouteKey = "/profile";
  static const String roommateProfileRouteKey = "/roommate/profile";
  static const String homePageRouteKey = "home-page";
  static const String messagePageRouteKey = "message-page";
  static const String wishlistPageRouteKey = "wishlist-page";
  static const String profilePagesRouteKey = "profile-pages";
  static const String personalInfoPageRouteKey = "personal-info-page";
  static const String settingsPageRouteKey = "settings-page";
  static const String supportPageRouteKey = "support-page";
  static const String privacyPolicyPageRouteKey = "privacy-policy-page";
  static const String bagPageRouteKey = "bag-page";
  static const String searchRouteKey = "/search";
  static const String roomDetailsRouteKey = "/room-details";
  static const String mainScreenRouteKey = "/main-screen";
  static const String chatScreenRouteKey = "/chat-screen";
  static const String signUpModeKey = "sign-up";
  static const String signInModeKey = "sign-in";
  static const String recentEmojiKey = "recent-emoji";
  static const String nameHeroKey = "name-hero";
  static const String titleHeroKey = "title-hero";
  static const String profilePicHeroKey = "profile-pic";
}

class AppConstants {
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  static IconData iconSelection(double rate) {
    switch (rate) {
      case 1 || 2:
        return Icons.star_border_rounded;
      case 3 || 4:
        return Icons.star_half_rounded;
      default:
        return Icons.star_rate_rounded;
    }
  }

  static String pageRouteToStringFormat(String input) {
    String formattedString = input
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    // Remove the trailing "page"
    if (formattedString.endsWith(' Page')) {
      formattedString =
          formattedString.substring(0, formattedString.length - 5);
    }

    return formattedString;
  }

  static Color iconColorSelection(double rate) {
    switch (rate) {
      case 1 || 2:
        return AppColors.red;
      case 3 || 4:
        return AppColors.orange[800] ?? AppColors.orange.withOpacity(0.7);
      default:
        return AppColors.orange;
    }
  }

  static MainAxisAlignment alignmentSelection(int align) {
    switch (align) {
      case 0:
        return MainAxisAlignment.start;
      case 1:
        return MainAxisAlignment.center;
      case 2:
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }

  static bool isNameValid(String? name) {
    if (name == null || name.isEmpty) {
      return false;
    }

    // Check if the name contains only alphabets and spaces
    RegExp regExp = RegExp(r'^[a-zA-Z ]+$');
    if (!regExp.hasMatch(name)) {
      return false;
    }

    // Check if the name starts and ends with an alphabet (optional)
    if (!RegExp(r'^[a-zA-Z].*[a-zA-Z]$').hasMatch(name)) {
      return false;
    }

    // If all checks pass, the name is valid
    return true;
  }

  static bool isPasswordValid(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    // Check if the password meets the minimum length requirement (you can adjust this)
    if (password.length < 8) {
      return false;
    }

    // Check if the password contains both letters and numbers
    if (!(RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password))) {
      return false;
    }

    // Additional checks or criteria can be added based on your requirements

    // If all checks pass, the password is considered valid
    return true;
  }

  static bool isEmailValid(String email) => EmailValidator.validate(email);

  static bool isPhoneValid(String selectedIsoCode, String phoneNum) =>
      PhoneNumber.isoCode(selectedIsoCode, phoneNum).isValid;
}
