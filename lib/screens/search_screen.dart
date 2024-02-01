import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../models/chip_data_model.dart';
import '../models/search_range_model.dart';
import '../styles.dart';
import 'auth_screen.dart';
import 'home_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchInputController;
  String selectedSortByType = "Hourly", selectedSortByDistance = "1km";
  RangeValues values = RangeValues(10, 100);
  final DateTime dateMin = DateTime(2003, 01, 01);
  final DateTime dateMax = DateTime(2010, 01, 01);
  SfRangeValues _values = SfRangeValues(40.0, 80.0);
  List<SearchRangeModel> rangeList = [];
  int maxChartY = 300,
      maxPrice = 200,
      minPrice = 0,
      selectedRating = 0,
      maxY = 200;
  List<int> selectedFacilities = [0];
  final FocusNode _focus = FocusNode();
  bool focused = false, showFilters = false;

  @override
  void initState() {
    _searchInputController = TextEditingController();
    _focus.addListener(_onFocusChange);
    // _searchInputController.addListener(_onTextControllerChange);
    for (int i = minPrice; i <= maxPrice; i++) {
      if (i % 20 == 0) {
        rangeList.add(
          SearchRangeModel(
            key: i,
            val: math.Random().nextInt(200),
          ),
        );
      }
    }

    for (var element in rangeList) {
      log(element.key.toString());
    }
    super.initState();
  }

  // void _onTextControllerChange() {
  //   setState(() {});
  // }

  void _onFocusChange() {
    if (_searchInputController.text.trim().isEmpty) {
      focused = false;
      showFilters = false;
    } else {
      focused = true;
    }
    setState(() {});
    log(focused.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          "Filter",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: (() async {}),
              child: CustomScrollView(
                physics: AppConstants.scrollPhysics,
                slivers: [
                  SliverAppBar(
                    leading: Container(),
                    toolbarHeight: 81,
                    pinned: true,
                    flexibleSpace: Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InputTextFormField(
                              focusNode: _focus,
                              controller: _searchInputController,
                              textInputType: TextInputType.text,
                              hint: "Searching for",
                              textInputAction: TextInputAction.search,
                              suffix: Icon(
                                Icons.search,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                          if (focused)
                            SizedBox(
                              width: 10,
                            ),
                          if (focused)
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  showFilters = !showFilters;
                                });
                              }),
                              child: Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryText,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.sort,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (!focused)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 10,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                bottom: 15,
                              ),
                              child: Text(
                                "Sort price by",
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.inactiveDotColor,
                                counterText: "",
                                prefixIcon: const Icon(
                                  Icons.work,
                                  color: AppColors.mainColor,
                                ),
                                prefixStyle: const TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 16,
                                ),
                                hintStyle: TextStyle(
                                  color: AppColors.hintTextColor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: AppColors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: AppColors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                              ),
                              style: const TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 16,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.mainColor,
                              ),
                              enableFeedback: true,
                              elevation: 5,
                              dropdownColor: AppColors.inactiveDotColor,
                              borderRadius: BorderRadius.circular(15),
                              value: selectedSortByType,
                              items: const [
                                DropdownMenuItem(
                                  child: Text("Hourly"),
                                  value: "Hourly",
                                ),
                                DropdownMenuItem(
                                  child: Text("Daily"),
                                  value: "Daily",
                                ),
                                DropdownMenuItem(
                                  child: Text("Weekly"),
                                  value: "Weekly",
                                ),
                                DropdownMenuItem(
                                  child: Text("Monthly"),
                                  value: "Monthly",
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSortByType = value ?? "";
                                });
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 20,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: AppColors.transparent,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                              ),
                              child: AspectRatio(
                                aspectRatio: 2,
                                child: BarChart(
                                  BarChartData(
                                    barTouchData: barTouchData,
                                    titlesData: buildTitleDate(),
                                    borderData: borderData,
                                    barGroups: rangeList
                                        .map(
                                          (e) => BarChartGroupData(
                                            x: e.key,
                                            barRods: [
                                              BarChartRodData(
                                                toY: e.key == 0
                                                    ? 0
                                                    : e.val.toDouble(),
                                                color: ((e.key >=
                                                            _values.start) &&
                                                        (e.key <= _values.end))
                                                    ? AppColors.activeDotColor
                                                    : AppColors
                                                        .inactiveDotColor,
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                    gridData: const FlGridData(show: false),
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: maxY.toDouble(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 3),
                              child: SfRangeSlider(
                                min: 0,
                                max: 200,
                                interval: 20,
                                inactiveColor: AppColors.inactiveSliderColor,
                                activeColor: AppColors.secondaryText,
                                stepSize: 20,
                                onChanged: (SfRangeValues val) {
                                  setState(() {
                                    _values = val;
                                  });
                                },
                                values: _values,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 17,
                                bottom: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (_values.start.toDouble().toInt())
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    (_values.end.toDouble().toInt()).toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                bottom: 15,
                              ),
                              child: Text(
                                "Distance",
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.inactiveDotColor,
                                prefixIcon: const Icon(
                                  Icons.work,
                                  color: AppColors.mainColor,
                                ),
                                prefixStyle: const TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 16,
                                ),
                                hintStyle: TextStyle(
                                  color: AppColors.hintTextColor,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: AppColors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: AppColors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                              ),
                              style: const TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 16,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.mainColor,
                              ),
                              enableFeedback: true,
                              elevation: 5,
                              dropdownColor: AppColors.inactiveDotColor,
                              borderRadius: BorderRadius.circular(15),
                              value: selectedSortByDistance,
                              items: const [
                                DropdownMenuItem(
                                  child: Text("Under 1km"),
                                  value: "1km",
                                ),
                                DropdownMenuItem(
                                  child: Text("Under 5km"),
                                  value: "5km",
                                ),
                                DropdownMenuItem(
                                  child: Text("Under 10km"),
                                  value: "10km",
                                ),
                                DropdownMenuItem(
                                  child: Text("Under 15km"),
                                  value: "15km",
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  selectedSortByDistance = value ?? "";
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                bottom: 15,
                              ),
                              child: Text(
                                "Rating",
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                ChipData(
                                  label: "All",
                                  key: 0,
                                ),
                                ChipData(
                                  label: "5",
                                  icon: Icons.star,
                                  key: 5,
                                ),
                                ChipData(
                                  label: "4",
                                  icon: Icons.star,
                                  key: 4,
                                ),
                                ChipData(
                                  label: "3",
                                  icon: Icons.star,
                                  key: 3,
                                ),
                                ChipData(
                                  label: "2",
                                  icon: Icons.star,
                                  key: 2,
                                ),
                                ChipData(
                                  label: "1",
                                  icon: Icons.star,
                                  key: 1,
                                ),
                              ].map(
                                (chip) {
                                  return InputChip(
                                    labelPadding: EdgeInsets.all(4),
                                    avatar: (chip.icon != null)
                                        ? Icon(
                                            chip.icon,
                                            color: AppColors.secondaryText,
                                            size: 20,
                                          )
                                        : null,
                                    onPressed: (() {
                                      selectedRating = chip.key;
                                      setState(() {});
                                    }),
                                    label: Text(chip.label),
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: (chip.key == selectedRating)
                                          ? AppColors.activeDotColor
                                          : AppColors.mainColor,
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor:
                                        (chip.key == selectedRating)
                                            ? AppColors.inactiveDotColor
                                            : AppColors.cardColorLight,
                                  );
                                },
                              ).toList(),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                bottom: 15,
                              ),
                              child: Text(
                                "Facilities",
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Wrap(
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
                                  return InputChip(
                                    labelPadding: EdgeInsets.all(4),
                                    avatar: (chip.icon != null)
                                        ? Icon(
                                            chip.icon,
                                            color: selectedFacilities
                                                    .contains(chip.key)
                                                ? AppColors.secondaryText
                                                : AppColors.hintTextColor,
                                            size: 20,
                                          )
                                        : null,
                                    onPressed: (() {
                                      if (selectedFacilities
                                          .contains(chip.key)) {
                                        selectedFacilities.remove(chip.key);
                                        setState(() {});
                                      } else {
                                        selectedFacilities.add(chip.key);
                                        setState(() {});
                                      }
                                    }),
                                    label: Text(chip.label),
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          selectedFacilities.contains(chip.key)
                                              ? AppColors.activeDotColor
                                              : AppColors.mainColor,
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor:
                                        selectedFacilities.contains(chip.key)
                                            ? AppColors.inactiveDotColor
                                            : AppColors.cardColorLight,
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GestureDetector(
                          onTap: (() {
                            Navigator.of(context).pushNamed(
                              AppKeys.roomDetailsRouteKey,
                              arguments: "123456",
                            );
                          }),
                          child: RoomListContainer(
                            image:
                                "https://images.pexels.com/photos/11509450/pexels-photo-11509450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                            roomName: "Minimalism Room",
                            rate: "\$12.50/1 hour",
                            locationName: "Newtown",
                            bedCount: 1,
                            bathroomCount: 1,
                            rating: 1.0,
                          ),
                        );
                      },
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ),
            if (showFilters)
              Positioned(
                right:
                    (showFilters ? 10 : MediaQuery.of(context).size.width) * -1,
                top: MediaQuery.of(context).size.height / 6.5,
                height: MediaQuery.of(context).size.height / 2,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 25,
                      left: 10,
                      bottom: 10,
                    ),
                    margin: const EdgeInsets.only(
                      left: 15,
                      bottom: 10,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.hintTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 15,
                          ),
                          child: Text(
                            "Sort price by",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inactiveDotColor,
                            counterText: "",
                            prefixIcon: const Icon(
                              Icons.work,
                              color: AppColors.mainColor,
                            ),
                            prefixStyle: const TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 16,
                            ),
                            hintStyle: TextStyle(
                              color: AppColors.hintTextColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.white,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.white,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 16,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.mainColor,
                          ),
                          enableFeedback: true,
                          elevation: 5,
                          dropdownColor: AppColors.inactiveDotColor,
                          borderRadius: BorderRadius.circular(15),
                          value: selectedSortByType,
                          items: const [
                            DropdownMenuItem(
                              child: Text("Hourly"),
                              value: "Hourly",
                            ),
                            DropdownMenuItem(
                              child: Text("Daily"),
                              value: "Daily",
                            ),
                            DropdownMenuItem(
                              child: Text("Weekly"),
                              value: "Weekly",
                            ),
                            DropdownMenuItem(
                              child: Text("Monthly"),
                              value: "Monthly",
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedSortByType = value ?? "";
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 20,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: BarChart(
                              BarChartData(
                                barTouchData: barTouchData,
                                titlesData: buildTitleDate(),
                                borderData: borderData,
                                barGroups: rangeList
                                    .map(
                                      (e) => BarChartGroupData(
                                        x: e.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.key == 0
                                                ? 0
                                                : e.val.toDouble(),
                                            color: ((e.key >= _values.start) &&
                                                    (e.key <= _values.end))
                                                ? AppColors.activeDotColor
                                                : AppColors.inactiveDotColor,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                                gridData: const FlGridData(show: false),
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxY.toDouble(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 3),
                          child: SfRangeSlider(
                            min: 0,
                            max: 200,
                            interval: 20,
                            inactiveColor: AppColors.inactiveSliderColor,
                            activeColor: AppColors.secondaryText,
                            stepSize: 20,
                            onChanged: (SfRangeValues val) {
                              setState(() {
                                _values = val;
                              });
                            },
                            values: _values,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 17,
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (_values.start.toDouble().toInt()).toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                (_values.end.toDouble().toInt()).toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Text(
                            "Distance",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inactiveDotColor,
                            prefixIcon: const Icon(
                              Icons.work,
                              color: AppColors.mainColor,
                            ),
                            prefixStyle: const TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 16,
                            ),
                            hintStyle: TextStyle(
                              color: AppColors.hintTextColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.white,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: AppColors.white,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 16,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.mainColor,
                          ),
                          enableFeedback: true,
                          elevation: 5,
                          dropdownColor: AppColors.inactiveDotColor,
                          borderRadius: BorderRadius.circular(15),
                          value: selectedSortByDistance,
                          items: const [
                            DropdownMenuItem(
                              child: Text("Under 1km"),
                              value: "1km",
                            ),
                            DropdownMenuItem(
                              child: Text("Under 5km"),
                              value: "5km",
                            ),
                            DropdownMenuItem(
                              child: Text("Under 10km"),
                              value: "10km",
                            ),
                            DropdownMenuItem(
                              child: Text("Under 15km"),
                              value: "15km",
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedSortByDistance = value ?? "";
                            });
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 15,
                          ),
                          child: Text(
                            "Rating",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            ChipData(
                              label: "All",
                              key: 0,
                            ),
                            ChipData(
                              label: "5",
                              icon: Icons.star,
                              key: 5,
                            ),
                            ChipData(
                              label: "4",
                              icon: Icons.star,
                              key: 4,
                            ),
                            ChipData(
                              label: "3",
                              icon: Icons.star,
                              key: 3,
                            ),
                            ChipData(
                              label: "2",
                              icon: Icons.star,
                              key: 2,
                            ),
                            ChipData(
                              label: "1",
                              icon: Icons.star,
                              key: 1,
                            ),
                          ].map(
                            (chip) {
                              return InputChip(
                                labelPadding: EdgeInsets.all(4),
                                avatar: (chip.icon != null)
                                    ? Icon(
                                        chip.icon,
                                        color: AppColors.secondaryText,
                                        size: 20,
                                      )
                                    : null,
                                onPressed: (() {
                                  selectedRating = chip.key;
                                  setState(() {});
                                }),
                                label: Text(chip.label),
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: (chip.key == selectedRating)
                                      ? AppColors.activeDotColor
                                      : AppColors.mainColor,
                                ),
                                side: BorderSide.none,
                                backgroundColor: (chip.key == selectedRating)
                                    ? AppColors.inactiveDotColor
                                    : AppColors.cardColorLight,
                              );
                            },
                          ).toList(),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            bottom: 15,
                          ),
                          child: Text(
                            "Facilities",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Wrap(
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
                              return InputChip(
                                labelPadding: EdgeInsets.all(4),
                                avatar: (chip.icon != null)
                                    ? Icon(
                                        chip.icon,
                                        color: selectedFacilities
                                                .contains(chip.key)
                                            ? AppColors.secondaryText
                                            : AppColors.hintTextColor,
                                        size: 20,
                                      )
                                    : null,
                                onPressed: (() {
                                  if (selectedFacilities.contains(chip.key)) {
                                    selectedFacilities.remove(chip.key);
                                    setState(() {});
                                  } else {
                                    selectedFacilities.add(chip.key);
                                    setState(() {});
                                  }
                                }),
                                label: Text(chip.label),
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: selectedFacilities.contains(chip.key)
                                      ? AppColors.activeDotColor
                                      : AppColors.mainColor,
                                ),
                                side: BorderSide.none,
                                backgroundColor:
                                    selectedFacilities.contains(chip.key)
                                        ? AppColors.inactiveDotColor
                                        : AppColors.cardColorLight,
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RoomListContainer extends StatelessWidget {
  const RoomListContainer({
    super.key,
    required this.image,
    required this.roomName,
    required this.rate,
    required this.locationName,
    required this.bedCount,
    required this.bathroomCount,
    required this.rating,
  });

  final String image, roomName, rate, locationName;
  final int bedCount, bathroomCount;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 115,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
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
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
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
                  roomName,
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
                        rate,
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          locationName,
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DetailWidget(
                      icon: Icons.bed,
                      count: bedCount.toString(),
                      iconColor: AppColors.mainColor,
                    ),
                    DetailWidget(
                      icon: Icons.bathtub_outlined,
                      count: bathroomCount.toString(),
                      iconColor: AppColors.mainColor,
                    ),
                    DetailWidget(
                      icon: AppConstants.iconSelection(rating),
                      count: rating.toString(),
                      iconColor: AppConstants.iconColorSelection(rating),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RatingContainer extends StatelessWidget {
  const RatingContainer({
    super.key,
    this.icon,
    required this.text,
    this.horizontalPadding,
    this.verticalPadding,
    this.iconColor,
    this.containerColor,
    this.textColor,
    required this.align,
  });

  final IconData? icon;
  final Color? iconColor, containerColor, textColor;
  final String text;
  final double? horizontalPadding, verticalPadding;
  final int align;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 200,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 20,
        vertical: verticalPadding ?? 15,
      ),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: AppConstants.alignmentSelection(align),
        children: [
          if (icon != null)
            Icon(
              icon!,
              color: iconColor,
              size: 20,
            ),
          if (icon != null)
            const SizedBox(
              width: 5,
            ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// class _BarChart extends StatelessWidget {
//   const _BarChart({
//     required this.done,
//     required this.personal,
//     required this.pending,
//     required this.business,
//     required this.deleted,
//     required this.count,
//   });
//
//   final int deleted;
//   final int done;
//   final int pending;
//   final int business;
//   final int personal;
//   final int count;
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         // barTouchData: barTouchData,
//         // titlesData: buildTitleDate(),
//         borderData: borderData,
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 toY: done.toDouble(),
//                 gradient: _barsGradient,
//               )
//             ],
//             showingTooltipIndicators: [0],
//           ),
//           // BarChartGroupData(
//           //   x: 1,
//           //   barRods: [
//           //     BarChartRodData(
//           //       toY: deleted.toDouble(),
//           //       gradient: _barsGradient,
//           //     )
//           //   ],
//           //   showingTooltipIndicators: [0],
//           // ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: pending.toDouble(),
//                 gradient: _barsGradient,
//               )
//             ],
//             showingTooltipIndicators: [0],
//           ),
//           BarChartGroupData(
//             x: 2,
//             barRods: [
//               BarChartRodData(
//                 toY: business.toDouble(),
//                 gradient: _barsGradient,
//               )
//             ],
//             showingTooltipIndicators: [0],
//           ),
//           BarChartGroupData(
//             x: 3,
//             barRods: [
//               BarChartRodData(
//                 toY: personal.toDouble(),
//                 gradient: _barsGradient,
//               )
//             ],
//             showingTooltipIndicators: [0],
//           ),
//         ],
//         gridData: const FlGridData(show: false),
//         alignment: BarChartAlignment.spaceAround,
//         maxY: count.toDouble(),
//       ),
//     );
//   }
//
//   buildTitleDate() => FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 35,
//             getTitlesWidget: (double val, TitleMeta meta) {
//               const textStyle = TextStyle(
//                 color: AppColors.mainColor,
//                 fontWeight: FontWeight.bold,
//               );
//               switch (val.toInt()) {
//                 case 0:
//                   return const Text(
//                     "\nDone",
//                     style: textStyle,
//                   );
//                 case 1:
//                   return const Text(
//                     "\nPending",
//                     style: textStyle,
//                   );
//                 case 2:
//                   return const Text(
//                     "\nBusiness",
//                     style: textStyle,
//                   );
//                 case 3:
//                   return const Text(
//                     "\nPersonal",
//                     style: textStyle,
//                   );
//                 case 4:
//                   return const Text(
//                     "\nPersonal",
//                     style: textStyle,
//                   );
//               }
//               return const Text("");
//             },
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       );
//
//   BarTouchData get barTouchData => BarTouchData(
//         enabled: false,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.transparent,
//           tooltipPadding: EdgeInsets.zero,
//           tooltipMargin: 8,
//           getTooltipItem: (
//             BarChartGroupData group,
//             int groupIndex,
//             BarChartRodData rod,
//             int rodIndex,
//           ) {
//             return BarTooltipItem(
//               rod.toY.round().toString(),
//               const TextStyle(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             );
//           },
//         ),
//       );
//
//   FlBorderData get borderData => FlBorderData(
//         show: false,
//       );
//
//   LinearGradient get _barsGradient => const LinearGradient(
//         colors: [
//           AppColors.orange,
//           AppColors.yellow,
//         ],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter,
//       );
//
//   List<BarChartGroupData> get barGroups => [
//         BarChartGroupData(
//           x: 0,
//           barRods: [
//             BarChartRodData(
//               toY: 8,
//               gradient: _barsGradient,
//             )
//           ],
//           showingTooltipIndicators: [0],
//         ),
//       ];
// }

BarTouchData get barTouchData => BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            const TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 0,
            ),
          );
        },
      ),
    );

buildTitleDate() => const FlTitlesData(
      show: false,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 35,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(
      show: false,
    );
