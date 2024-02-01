import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:homies/constants.dart';
import 'package:homies/models/notification_model.dart';
import 'package:homies/screens/auth_screen.dart';
import 'package:homies/screens/onboarding_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../models/question_model.dart';
import '../styles.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({
    Key? key,
    required this.route,
  }) : super(key: key);

  final String route;

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  XFile? newProfilePicture;
  bool isChangePhotoStarted = false,
      isPhoneVerified = false,
      isEmailVerified = false;
  String? name = "Rupam Karmakar",
      phone = "+91 8583006460",
      email = "rupamkarmakar1238@gmail.com";
  TextEditingController currPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController retypePassController = TextEditingController();
  bool isCurrPassVisible = true,
      isNewPassVisible = true,
      isRetypePassVisible = true;

  List<Question> questionList = [
    Question(ans: "ans1", q: "q1", isExpanded: false),
    Question(ans: "ans2", q: "q2", isExpanded: false),
    Question(ans: "ans3", q: "q3", isExpanded: false),
    Question(ans: "ans4", q: "q4", isExpanded: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: ((ctx) {
          switch (widget.route) {
            case AppKeys.personalInfoPageRouteKey:
              return Scaffold(
                bottomNavigationBar: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 15,
                  ),
                  height: 70,
                  child: CustomButton(
                    buttonColor: AppColors.activeButtonColor,
                    textColor: AppColors.white,
                    head: "Save",
                    onTap: (() {}),
                  ),
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.mainColor,
                      centerTitle: true,
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
                        AppConstants.pageRouteToStringFormat(widget.route),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 25,
                          bottom: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag:
                                  "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: (newProfilePicture != null)
                                    ? Image.file(File(newProfilePicture!.path))
                                        .image
                                    : CachedNetworkImageProvider(
                                        "https://images.pexels.com/photos/19804055/pexels-photo-19804055/free-photo-of-xoan.jpeg",
                                      ),
                              ),
                            ),
                            if (!isChangePhotoStarted)
                              CustomButton(
                                buttonColor: AppColors.inactiveDotColor,
                                textColor: AppColors.activeButtonColor,
                                head: "Change Photo",
                                onTap: (() {
                                  isChangePhotoStarted = true;
                                  setState(() {});
                                }),
                              ),
                            if (isChangePhotoStarted)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    buttonColor: AppColors.inactiveDotColor,
                                    textColor: AppColors.activeButtonColor,
                                    head: "Change Photo",
                                    widget: Icon(
                                      Icons.photo_library_outlined,
                                      color: AppColors.activeButtonColor,
                                    ),
                                    onTap: (() async {
                                      newProfilePicture =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      setState(() {});
                                    }),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CustomButton(
                                    buttonColor: AppColors.inactiveDotColor,
                                    textColor: AppColors.activeButtonColor,
                                    head: "Change Photo",
                                    widget: Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.activeButtonColor,
                                    ),
                                    onTap: (() async {
                                      newProfilePicture =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                      );
                                      setState(() {});
                                    }),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomHeadingText(
                        head: 'Your Name',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomDisplayContainer(
                        label: name!,
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                        ),
                        onTap: (() async {
                          name = await updatingModalBottomSheet(
                                context: context,
                                hint: 'Enter Your Name',
                                head: 'Your New Name',
                                textInputType: TextInputType.name,
                              ) ??
                              name;
                          setState(() {});
                        }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomHeadingText(
                        head: 'Phone Number',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomDisplayContainer(
                        label: phone!,
                        widget: isPhoneVerified
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.green,
                                ),
                              )
                            : null,
                        onTap: (() async {
                          String? temp;
                          temp = await updatingModalBottomSheet(
                            context: context,
                            hint: 'Enter Your Phone',
                            head: 'Your New Phone',
                            textInputType: TextInputType.phone,
                          );
                          if (phone != temp && temp != null) {
                            isPhoneVerified = await updatingModalBottomSheet(
                                  context: context,
                                  hint: 'Enter OTP',
                                  head: 'OTP sent to your phone number',
                                  textInputType: TextInputType.visiblePassword,
                                ) ??
                                isPhoneVerified;
                          }
                          setState(() {});
                        }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomHeadingText(
                        head: 'Email',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomDisplayContainer(
                        label: email!,
                        widget: isEmailVerified
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.green,
                                ),
                              )
                            : null,
                        onTap: (() async {
                          String? temp;
                          temp = await updatingModalBottomSheet(
                            context: context,
                            hint: 'Enter Your Email',
                            head: 'Your New Email',
                            textInputType: TextInputType.emailAddress,
                          );
                          if (phone != temp && temp != null) {
                            isEmailVerified = await updatingModalBottomSheet(
                                  context: context,
                                  hint: 'Enter OTP',
                                  head: 'OTP sent to your email address',
                                  textInputType: TextInputType.visiblePassword,
                                ) ??
                                isEmailVerified;
                          }
                          setState(() {});
                        }),
                      ),
                    ),
                  ],
                ),
              );
            case AppKeys.settingsPageRouteKey:
              List<NotificationModel> notificationList = [
                NotificationModel(
                  id: "1",
                  title: "Booking Activities",
                ),
                NotificationModel(
                  id: "2",
                  title: "Messages",
                ),
                NotificationModel(
                  id: "3",
                  title: "Promotions",
                ),
              ];
              return Scaffold(
                bottomNavigationBar: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 15,
                  ),
                  height: 70,
                  child: CustomButton(
                    buttonColor: AppColors.activeButtonColor,
                    textColor: AppColors.white,
                    head: "Save",
                    onTap: (() {}),
                  ),
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.mainColor,
                      centerTitle: true,
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
                        AppConstants.pageRouteToStringFormat(widget.route),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: CustomHeadingText(
                    //     head: "Language",
                    //   ),
                    // ),
                    // SliverToBoxAdapter(),
                    SliverToBoxAdapter(
                      child: CustomHeadingText(
                        head: "Notification",
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: notificationList
                              .map(
                                (e) => NotificationCheckContainer(
                                  title: e.title,
                                  onChanged: ((val) {}),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomHeadingText(
                        head: "Change your password",
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 10,
                        ),
                        child: InputTextFormField(
                          controller: currPassController,
                          textInputType: TextInputType.visiblePassword,
                          hint: "Your current password",
                          fillColor: AppColors.inactiveDotColor,
                          obscure: isCurrPassVisible,
                          suffix: IconButton(
                            onPressed: (() {
                              isCurrPassVisible = !isCurrPassVisible;
                              setState(() {});
                            }),
                            icon: Icon(
                              isCurrPassVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 10,
                        ),
                        child: InputTextFormField(
                          controller: newPassController,
                          textInputType: TextInputType.visiblePassword,
                          hint: "Your New password",
                          fillColor: AppColors.inactiveDotColor,
                          obscure: isNewPassVisible,
                          suffix: IconButton(
                            onPressed: (() {
                              isNewPassVisible = !isNewPassVisible;
                              setState(() {});
                            }),
                            icon: Icon(
                              isNewPassVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 10,
                        ),
                        child: InputTextFormField(
                          controller: retypePassController,
                          textInputType: TextInputType.visiblePassword,
                          hint: "Retype Your New password",
                          fillColor: AppColors.inactiveDotColor,
                          obscure: isRetypePassVisible,
                          suffix: IconButton(
                            onPressed: (() {
                              isRetypePassVisible = !isRetypePassVisible;
                              setState(() {});
                            }),
                            icon: Icon(
                              isRetypePassVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case AppKeys.supportPageRouteKey:
              return Scaffold(
                body: ExpandableNotifier(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: AppColors.mainColor,
                        centerTitle: true,
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
                          AppConstants.pageRouteToStringFormat(widget.route),
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonColor: AppColors.activeButtonColor,
                                  textColor: AppColors.white,
                                  head: "Call",
                                  onTap: (() {}),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CustomButton(
                                  buttonColor: AppColors.secondaryText,
                                  textColor: AppColors.white,
                                  head: "Chat",
                                  onTap: (() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CustomHeadingText(
                          head: "Frequently asked question",
                        ),
                      ),
                      // SliverList(
                      //   delegate: SliverChildBuilderDelegate(
                      //     (context, index) {
                      //       bool isExpanded = false;
                      //       return Column(
                      //         children: [
                      //           GestureDetector(
                      //             onTap: (() {
                      //               isExpanded = !isExpanded;
                      //               setState(() {});
                      //             }),
                      //             child: Container(
                      //               margin: EdgeInsets.only(
                      //                 left: 25,
                      //                 right: 25,
                      //                 top: 5,
                      //                 bottom: 5,
                      //               ),
                      //               padding: EdgeInsets.only(
                      //                 left: 15,
                      //                 right: 15,
                      //                 top: 12,
                      //                 bottom: 12,
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.inactiveDotColor,
                      //                 borderRadius: BorderRadius.circular(15),
                      //               ),
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Text(
                      //                     "Lorem ipsum dolor sit amet $isExpanded",
                      //                     style: TextStyle(
                      //                       color: AppColors.mainColor,
                      //                       fontWeight: FontWeight.w400,
                      //                     ),
                      //                   ),
                      //                   Icon(
                      //                     isExpanded
                      //                         ? Icons.arrow_drop_up_rounded
                      //                         : Icons.arrow_drop_down_rounded,
                      //                     color: AppColors.inactiveTextColor,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //     childCount: questionList.length,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            case AppKeys.privacyPolicyPageRouteKey:
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.mainColor,
                      centerTitle: true,
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
                        AppConstants.pageRouteToStringFormat(widget.route),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Hero(
                            tag: AppKeys.profilePicHeroKey,
                            child: CircleAvatar(
                              radius: 30,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            default:
              return Container();
          }
        }),
      ),
    );
  }

  Future<dynamic> updatingModalBottomSheet({
    required BuildContext context,
    required String hint,
    required String head,
    required TextInputType textInputType,
  }) {
    TextEditingController textEditingController = TextEditingController();
    String countryCode = "+91", isoCode = "IN";
    bool isVerified = false, isValid = true;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: ((ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ModalBottomSheetContainer(
            textEditingController: textEditingController,
            countryCode: countryCode,
            isoCode: isoCode,
            isVerified: isVerified,
            isValid: isValid,
            head: head,
            hint: hint,
            textInputType: textInputType,
            ctx: ctx,
          ),
        );
      }),
    );
  }
}

class NotificationCheckContainer extends StatelessWidget {
  const NotificationCheckContainer({
    super.key,
    required this.title,
    required this.onChanged,
  });

  final String title;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: true,
          activeColor: AppColors.activeButtonColor,
          side: BorderSide(width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onChanged: onChanged,
        ),
        Text(
          title,
          style: TextStyle(
            color: AppColors.mainColor,
          ),
        ),
      ],
    );
  }
}

class ModalBottomSheetContainer extends StatefulWidget {
  const ModalBottomSheetContainer({
    super.key,
    required this.textEditingController,
    required this.countryCode,
    required this.isoCode,
    required this.isVerified,
    required this.isValid,
    required this.head,
    required this.hint,
    required this.textInputType,
    required this.ctx,
  });

  final String countryCode, isoCode, head, hint;
  final bool isVerified, isValid;
  final TextInputType textInputType;
  final BuildContext ctx;
  final TextEditingController textEditingController;

  @override
  State<ModalBottomSheetContainer> createState() =>
      _ModalBottomSheetContainerState();
}

class _ModalBottomSheetContainerState extends State<ModalBottomSheetContainer> {
  String countryCode = "", isoCode = "";
  bool isVerified = false, isValid = false;
  @override
  void initState() {
    countryCode = widget.countryCode;
    isoCode = widget.isoCode;
    isVerified = widget.isVerified;
    isValid = widget.isValid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            child: CustomHeadingText(
              head: widget.head,
            ),
            alignment: Alignment.centerLeft,
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: InputTextFormField(
              autoFocus: true,
              fillColor: AppColors.inactiveDotColor,
              controller: widget.textEditingController,
              textInputType: widget.textInputType,
              hint: widget.hint,
              prefix: (widget.textInputType == TextInputType.phone)
                  ? CountryCodePicker(
                      showFlagMain: false,
                      showFlagDialog: true,
                      onInit: ((code) {
                        if (code != null) {
                          countryCode = code.dialCode!;
                          isoCode = code.code!;
                          Future.delayed(
                            Duration.zero,
                            (() {
                              setState(() {});
                            }),
                          );
                        }
                      }),
                      onChanged: ((code) {
                        countryCode = code.dialCode!;
                        isoCode = code.code!;
                        isValid = AppConstants.isPhoneValid(
                            isoCode, widget.textEditingController.text.trim());
                        setState(() {});
                      }),
                      initialSelection: 'IN',
                    )
                  : null,
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          if (!isValid)
            Text(
              "Please fill the ${widget.textInputType == TextInputType.phone ? "phone number" : widget.textInputType == TextInputType.emailAddress ? "email address" : widget.textInputType == TextInputType.visiblePassword ? "otp" : "name "} correctly",
              style: TextStyle(
                color: AppColors.red,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonColor: AppColors.activeButtonColor.withOpacity(0.1),
                    textColor: AppColors.inactiveTextColor,
                    head: "Cancel",
                    onTap: (() {
                      Navigator.pop(widget.ctx);
                    }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomButton(
                    buttonColor: AppColors.activeButtonColor,
                    textColor: AppColors.white,
                    head: "Submit",
                    onTap: (() {
                      if (widget.textEditingController.text.trim().isNotEmpty) {
                        switch (widget.textInputType) {
                          case TextInputType.visiblePassword:
                            {
                              if (widget.textEditingController.text.trim() ==
                                  "2003") {
                                isVerified = true;
                                Navigator.pop(
                                  widget.ctx,
                                  isVerified,
                                );
                              } else {
                                isValid = false;
                                setState(() {});
                              }
                            }
                          case TextInputType.phone:
                            {
                              if (AppConstants.isPhoneValid(isoCode,
                                  widget.textEditingController.text.trim())) {
                                Navigator.pop(
                                  widget.ctx,
                                  "$countryCode ${widget.textEditingController.text.trim()}",
                                );
                              } else {
                                isValid = false;
                                setState(() {});
                              }
                            }

                          case TextInputType.emailAddress:
                            {
                              if (AppConstants.isEmailValid(
                                  widget.textEditingController.text.trim())) {
                                Navigator.pop(widget.ctx,
                                    widget.textEditingController.text.trim());
                              } else {
                                isValid = false;
                                setState(() {});
                              }
                            }
                          default:
                            Navigator.pop(
                              widget.ctx,
                              widget.textEditingController.text.trim(),
                            );
                        }
                      }
                    }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomDisplayContainer extends StatelessWidget {
  const CustomDisplayContainer({
    super.key,
    required this.label,
    this.margin,
    required this.onTap,
    this.widget,
  });

  final String label;
  final EdgeInsets? margin;
  final VoidCallback onTap;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: margin ??
          EdgeInsets.only(
            left: 25,
            right: 25,
          ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: AppColors.inactiveSliderColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (widget != null)
            SizedBox(
              child: widget,
            ),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.edit,
              color: AppColors.inactiveTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHeadingText extends StatelessWidget {
  const CustomHeadingText({
    super.key,
    required this.head,
    this.fontSize,
    this.textStyle,
    this.padding,
  });

  final String head;
  final double? fontSize;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            left: 25,
            right: 25,
            top: 15,
            bottom: 10,
          ),
      child: Text(
        head,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 12,
              color: AppColors.mainColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
