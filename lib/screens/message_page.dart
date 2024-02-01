import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/chat_model.dart';
import 'package:homies/screens/auth_screen.dart';

import '../styles.dart';
import 'home_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _chatTypeTabController;
  late TextEditingController _searchConvoController;
  int screenIndex = 0;

  @override
  void initState() {
    _chatTypeTabController = TabController(length: 2, vsync: this);
    _searchConvoController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: (() async {}),
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: true,
            backgroundColor: AppColors.mainColor,
            title: Text(
              "Message",
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
                  controller: _chatTypeTabController,
                  tabs: const [
                    CustomTabBarItems(
                      label: "Chat",
                    ),
                    CustomTabBarItems(
                      label: "Service",
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (screenIndex == 0)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                child: InputTextFormField(
                  controller: _searchConvoController,
                  textInputType: TextInputType.text,
                  hint: "Looking for conversation",
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
                        AppKeys.chatScreenRouteKey,
                        arguments: ChatScreenNavigateModel(
                          name: "Rupam",
                        ),
                      );
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 115,
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                        top: 10,
                        bottom: 10,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inactiveDotColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            width: 91,
                            height: 91,
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
                                  "Karen Smith",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ptSerif(
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Did you come in time Did you come in time Did you come in time Did you come in time ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 7,
                                      width: 7,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryText,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "3 hours ago",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.inactiveTextColor,
                                  ),
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
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 115,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    padding: EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inactiveDotColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: 91,
                          height: 91,
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
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Your booking has been completed",
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.ptSerif(
                                        color: AppColors.mainColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryText,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "3 hours ago",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.inactiveTextColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
