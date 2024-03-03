import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/onboard_slider_model.dart';
import 'package:homies/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _pageController;
  int activeIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/onboard-1.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 25,
              child: CustomButton(
                horizontal: 20,
                vertical: 8,
                buttonColor: AppColors.white.withOpacity(0.2),
                textColor: AppColors.white,
                head: "Skip",
                onTap: (() {
                  Navigator.pushReplacementNamed(
                    context,
                    "/auth",
                    arguments: "sign-in",
                  );
                }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(
                  left: 47,
                  right: 47,
                  bottom: 30,
                  top: 20,
                ),
                height: MediaQuery.of(context).size.height / 2.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: sliderList.length,
                        onPageChanged: ((active) {
                          activeIndex = active;
                          setState(() {});
                        }),
                        itemBuilder: ((ctx, i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SliderHeadText(index: i),
                              Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              SliderDesText(index: i),
                            ],
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: sliderList.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: AppColors.inactiveDotColor,
                          activeDotColor: AppColors.activeDotColor,
                          spacing: 20,
                          radius: 5,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (activeIndex != sliderList.length - 1)
                          CustomButton(
                            textColor: (activeIndex != 0)
                                ? AppColors.white
                                : AppColors.inactiveTextColor,
                            buttonColor: (activeIndex != 0)
                                ? AppColors.activeButtonColor
                                : AppColors.inactiveButtonColor,
                            head: "Back",
                            onTap: (activeIndex != 0)
                                ? (() {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  })
                                : null,
                          ),
                        if (activeIndex == sliderList.length - 1)
                          CustomButton(
                            textColor: AppColors.white,
                            buttonColor: AppColors.activeButtonColor,
                            head: "Sign Up",
                            onTap: (() {
                              Navigator.pushReplacementNamed(
                                context,
                                "/auth",
                                arguments: AppKeys.signUpModeKey,
                              );
                            }),
                          ),
                        if (activeIndex != sliderList.length - 1)
                          CustomButton(
                            textColor: (activeIndex != sliderList.length - 1)
                                ? AppColors.white
                                : AppColors.inactiveTextColor,
                            buttonColor: (activeIndex != sliderList.length - 1)
                                ? AppColors.activeButtonColor
                                : AppColors.inactiveButtonColor,
                            head: "Next",
                            onTap: (activeIndex != sliderList.length - 1)
                                ? (() {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  })
                                : null,
                          ),
                        if (activeIndex == sliderList.length - 1)
                          CustomButton(
                            textColor: AppColors.white,
                            buttonColor: AppColors.activeButtonColor,
                            head: "Sign In",
                            onTap: (() {
                              Navigator.pushNamed(
                                context,
                                "/auth",
                                arguments: AppKeys.signInModeKey,
                              );
                            }),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Positioned(
            //   top: MediaQuery.of(context).size.height / 1.9,
            //   child: Container(
            //     height: 50,
            //     width: 50,
            //     decoration: BoxDecoration(
            //       color: AppColors.white,
            //       borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(50),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonColor,
    required this.textColor,
    required this.head,
    required this.onTap,
    this.horizontal,
    this.vertical,
    this.topMargin,
    this.bottomMargin,
    this.leftMargin,
    this.rightMargin,
    this.widget,
  });

  final Color buttonColor, textColor;
  final String head;
  final VoidCallback? onTap;
  final double? horizontal, vertical;
  final double? topMargin, bottomMargin, leftMargin, rightMargin;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(
          top: topMargin ?? 20,
          bottom: bottomMargin ?? 0,
          left: leftMargin ?? 0,
          right: rightMargin ?? 0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: vertical ?? 11,
          horizontal: horizontal ?? 32,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: buttonColor,
        ),
        child: Center(
          child: widget ??
              Text(
                head,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
        ),
      ),
    );
  }
}

class SliderDesText extends StatelessWidget {
  const SliderDesText({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Text(
      sliderList[index].des,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class SliderHeadText extends StatelessWidget {
  const SliderHeadText({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Text(
      sliderList[index].head,
      style: GoogleFonts.ptSerif(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.activeButtonColor,
      ),
    );
  }
}

class SliderImage extends StatelessWidget {
  const SliderImage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        sliderList[index].image,
        fit: BoxFit.cover,
      ),
    );
  }
}
