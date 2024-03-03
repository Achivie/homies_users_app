import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.placemarks,
  }) : super(key: key);

  final List<Placemark>? placemarks;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _stayTypeTabController;
  int? selectedRoomType, selectedHomeIndex = 0;

  @override
  void initState() {
    _stayTypeTabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: (() async {}),
      child: CustomScrollView(
        physics: AppConstants.scrollPhysics,
        slivers: [
          SliverAppBar(
            toolbarHeight: 160,
            backgroundColor: AppColors.mainColor,
            leading: Container(),
            flexibleSpace: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: 5,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Hi ",
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                Hero(
                                  tag: AppKeys.nameHeroKey,
                                  child: Text(
                                    "Rupam",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  ", you're at",
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 80,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.white,
                                    size: 30,
                                  ),
                                  Expanded(
                                    child: Text(
                                      (widget.placemarks != null)
                                          ? "${widget.placemarks![0].street}, ${widget.placemarks![0].subLocality!}, ${widget.placemarks![0].administrativeArea}"
                                          : "Loading...",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: AppColors.white,

                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag:
                              "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pushNamed(
                                  context, AppKeys.profileRouteKey);
                            }),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Expanded(
                    //   child: InputTextFormField(
                    //     controller: _searchInputController,
                    //     textInputType: TextInputType.text,
                    //     hint: "Searching for",
                    //     textInputAction: TextInputAction.search,
                    //     suffix: Icon(
                    //       Icons.search,
                    //       color: AppColors.mainColor,
                    //     ),
                    //   ),
                    // ),

                    GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, AppKeys.searchRouteKey);
                      }),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Looking for",
                              style: TextStyle(
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: AppColors.mainColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              // padding: EdgeInsets.symmetric(
              //   vertical: 20,
              //   horizontal: 25,
              // ),
              decoration: BoxDecoration(
                color: AppColors.inactiveDotColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: TabBar(
                  onTap: ((index) {
                    HapticFeedback.heavyImpact();
                  }),
                  indicatorColor: AppColors.transparent,
                  enableFeedback: true,
                  splashBorderRadius: BorderRadius.circular(20),
                  splashFactory: NoSplash.splashFactory,
                  // physics: AppColors.scrollPhysics,
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
                  controller: _stayTypeTabController,
                  tabs: const [
                    CustomTabBarItems(
                      label: "All",
                    ),
                    CustomTabBarItems(
                      label: "Stay",
                    ),
                    CustomTabBarItems(
                      label: "Flat",
                    ),
                    // CustomTabBarItems(
                    //   label: "DELETED",
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollPhysics: AppConstants.scrollPhysics,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: (() {
                        Navigator.of(context).pushNamed(
                          AppKeys.roomDetailsRouteKey,
                          arguments: "123456",
                        );
                      }),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(
                                left: 25,
                                right: 15,
                                bottom: 25,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.transparent,
                                    AppColors.transparent,
                                    AppColors.mainColor,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      IconButton(
                                        onPressed: (() {}),
                                        icon: Icon(
                                          Icons.favorite_border_rounded,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: AppColors.white,
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "\$12.50/1 hour",
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Distance: 1.5km",
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "from College".toLowerCase(),
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 10,
                left: 25,
                right: 25,
              ),
              child: Text(
                "Picked for you",
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: EdgeInsets.only(
                bottom: 10,
                left: 25,
                right: 25,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: ((ctx, index) {
                  return GestureDetector(
                    onTap: (() {
                      selectedRoomType = index;
                      setState(() {});
                    }),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (index == selectedRoomType)
                            ? AppColors.activeButtonColor
                            : AppColors.inactiveDotColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            width: 54,
                            height: 54,
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
                            child: Text(
                              "Duplex Room",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: (index == selectedRoomType)
                                    ? AppColors.white
                                    : AppColors.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 10,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 285,
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 25,
                right: 25,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: ((ctx, index) {
                  return Container(
                    width: 239,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.inactiveDotColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImage(
                          height: 155,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Stack(
                            children: [
                              Container(
                                // margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 30,
                                  child: Container(
                                    height: 36,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.4),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.favorite_border_rounded,
                                        color: AppColors.inactiveDotColor,
                                      ),
                                    ),
                                  )),
                            ],
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Minimalism Room",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ptSerif(
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.mainColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "\$12.50/1 hour",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "D Block",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Newtown",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DetailWidget(
                                icon: Icons.bed,
                                count: "1",
                                iconColor: AppColors.mainColor,
                              ),
                              DetailWidget(
                                icon: Icons.bathtub_outlined,
                                count: "1",
                                iconColor: AppColors.mainColor,
                              ),
                              DetailWidget(
                                icon: Icons.star,
                                count: "5.0",
                                iconColor: AppColors.orange,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 10,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 10,
                left: 25,
                right: 25,
              ),
              child: Text(
                "Near to you",
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
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
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                              "Minimalism Room",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ptSerif(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.mainColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "\$12.50/1 hour",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Newtown",
                                  style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DetailWidget(
                                  icon: Icons.bed,
                                  count: "1",
                                  iconColor: AppColors.mainColor,
                                ),
                                DetailWidget(
                                  icon: Icons.bathtub_outlined,
                                  count: "1",
                                  iconColor: AppColors.mainColor,
                                ),
                                DetailWidget(
                                  icon: Icons.star,
                                  count: "5.0",
                                  iconColor: AppColors.orange,
                                ),
                              ],
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

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
    required this.icon,
    required this.count,
    required this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String count;
  final Color iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          count,
          style: TextStyle(
            color: textColor ?? AppColors.mainColor,
          ),
        ),
      ],
    );
  }
}

class CustomTabBarItems extends StatelessWidget {
  const CustomTabBarItems({
    super.key,
    required this.label,
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: AppColors.activeButtonColor,
        // ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
        ),
      ),
    );
  }
}
