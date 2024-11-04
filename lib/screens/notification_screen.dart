import 'package:flutter/material.dart';
import 'package:homies/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: AppColors.mainColor,
    );
  }
}
