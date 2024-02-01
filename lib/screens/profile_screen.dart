import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homies/constants.dart';

import '../styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              stretchModes: const <StretchMode>[],
              background: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag:
                          "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1.5,
                            color: AppColors.white,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(
                              context,
                              AppKeys.imagePreviewRouteKey,
                              arguments:
                                  "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                            );
                          }),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Henry Quill",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.secondaryText,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "320 points",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListContainer(
              label: 'Personal Info',
              icon: Icons.person_outline_rounded,
              onTap: (() {
                Navigator.pushNamed(
                  context,
                  AppKeys.profilePagesRouteKey,
                  arguments: AppKeys.personalInfoPageRouteKey,
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: ListContainer(
              label: 'Settings',
              icon: Icons.settings_outlined,
              onTap: (() {
                Navigator.pushNamed(
                  context,
                  AppKeys.profilePagesRouteKey,
                  arguments: AppKeys.settingsPageRouteKey,
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: ListContainer(
              label: 'Support',
              icon: Icons.support_agent_rounded,
              onTap: (() {
                Navigator.pushNamed(
                  context,
                  AppKeys.profilePagesRouteKey,
                  arguments: AppKeys.supportPageRouteKey,
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: ListContainer(
              label: 'Privacy & Policy',
              icon: Icons.description_outlined,
              onTap: (() {
                Navigator.pushNamed(
                  context,
                  AppKeys.profilePagesRouteKey,
                  arguments: AppKeys.privacyPolicyPageRouteKey,
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: ListContainer(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              containerColor: AppColors.inactiveDotColor,
              iconColor: AppColors.inactiveTextColor,
              onTap: (() {}),
            ),
          ),
        ],
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  const ListContainer({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.containerColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor, containerColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.inactiveSliderColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: containerColor ??
                        AppColors.secondaryText.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.orange,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.inactiveTextColor,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
