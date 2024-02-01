import 'dart:async';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/constants.dart';
import 'package:homies/screens/onboarding_screen.dart';
import 'package:homies/styles.dart';
import 'package:pinput/pinput.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.signMode}) : super(key: key);

  final String signMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController,
      _phoneNumberController,
      _emailController,
      _passwordController,
      _confirmPassController;
  String countryCode = "+91", message = "", isoCode = "IN", mode = "";
  bool passVisibility = true,
      confirmPassVisibility = true,
      isPhoneNumValid = false,
      emailVerified = false,
      phoneVerified = false,
      emailVerificationStart = false,
      phoneVerificationStart = false;
  int remainingTime = 0;
  late TabController _tabController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPassController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    mode = widget.signMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Image.asset("assets/auth-vector.png"),
            ),
          ),
          if (mode == AppKeys.signUpModeKey)
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "H",
                            style: GoogleFonts.ptSerif(
                              color: AppColors.secondaryText,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Homies".toUpperCase(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          InputField(
                            textInputType: TextInputType.name,
                            head: "Your Full Name",
                            hint: "E.g John Smith",
                            controller: _nameController,
                            onChanged: ((name) {
                              setState(() {});
                            }),
                            // validator: validateName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!emailVerified)
                            InputField(
                              textInputType: TextInputType.emailAddress,
                              head: "Email",
                              hint: "example@achivie.com",
                              controller: _emailController,
                              suffix: TextButton(
                                onPressed: (() {
                                  if (EmailValidator.validate(
                                      _emailController.text.trim())) {
                                    emailVerificationStart = true;
                                    setState(() {});
                                    Timer.periodic(Duration(seconds: 1),
                                        (timer) {
                                      if (remainingTime < 10) {
                                        remainingTime++;
                                      } else if (remainingTime == 10) {
                                        timer.cancel();
                                      }
                                      setState(() {});
                                    });
                                  } else {
                                    // log("Enter a valid email");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackbar().authSnackBar(
                                        message: "Enter a valid email",
                                        context: context,
                                      ),
                                    );
                                  }
                                }),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: AppColors.activeButtonColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onChanged: ((email) {
                                setState(() {});
                              }),
                            ),
                          if (emailVerified)
                            VerifiedDisplayField(
                              text: _emailController.text.trim(),
                              head: "Email",
                              onTap: (() {
                                emailVerified = false;
                                remainingTime = 0;
                                setState(() {});
                              }),
                              btnText: "Change Email",
                            ),
                          if (emailVerificationStart)
                            SizedBox(
                              height: 10,
                            ),
                          if (emailVerificationStart)
                            PinVerificationField(
                              remainingTime: remainingTime,
                              message: "OTP sent to your given email. ",
                              onCompleted: ((pin) {
                                if (pin == "70803") {
                                  emailVerified = true;
                                  emailVerificationStart = false;
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackbar().authSnackBar(
                                      message: "Please enter the correct OTP",
                                      context: context,
                                    ),
                                  );
                                }
                              }),
                              onTap: (() {
                                remainingTime = 0;
                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  if (remainingTime < 10) {
                                    remainingTime++;
                                  } else if (remainingTime == 10) {
                                    timer.cancel();
                                  }
                                  setState(() {});
                                });
                              }),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!phoneVerified)
                            InputField(
                              textInputType: TextInputType.phone,
                              head: "Phone Number",
                              hint: "E.g 0123456789",
                              controller: _phoneNumberController,
                              prefix: CountryCodePicker(
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
                                  setState(() {});
                                }),
                                initialSelection: 'IN',
                              ),
                              suffix: TextButton(
                                onPressed: (() {
                                  if (AppConstants.isPhoneValid(isoCode,
                                      _phoneNumberController.text.trim())) {
                                    phoneVerificationStart = true;
                                    setState(() {});
                                    Timer.periodic(Duration(seconds: 1),
                                        (timer) {
                                      if (remainingTime < 10) {
                                        remainingTime++;
                                      } else if (remainingTime == 10) {
                                        timer.cancel();
                                      }
                                      setState(() {});
                                    });
                                  } else {
                                    // log("Enter a valid email");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackbar().authSnackBar(
                                        message: "Enter a valid phone number",
                                        context: context,
                                      ),
                                    );
                                  }
                                }),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: AppColors.activeButtonColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onChanged: ((phone) {
                                setState(() {});
                              }),
                            ),
                          if (phoneVerified)
                            VerifiedDisplayField(
                              text: countryCode +
                                  " " +
                                  _phoneNumberController.text.trim(),
                              head: "Phone Number",
                              onTap: (() {
                                phoneVerified = false;
                                remainingTime = 0;
                                setState(() {});
                              }),
                              btnText: "Change Phone",
                            ),
                          if (phoneVerificationStart)
                            SizedBox(
                              height: 10,
                            ),
                          if (phoneVerificationStart)
                            PinVerificationField(
                              remainingTime: remainingTime,
                              message: "OTP sent to your given phone number. ",
                              onCompleted: ((pin) {
                                if (pin == "70803") {
                                  phoneVerified = true;
                                  phoneVerificationStart = false;
                                  setState(() {});
                                }
                              }),
                              onTap: (() {
                                remainingTime = 0;
                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  if (remainingTime < 10) {
                                    remainingTime++;
                                  } else if (remainingTime == 10) {
                                    timer.cancel();
                                  }
                                  setState(() {});
                                });
                              }),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          InputField(
                            enableInteractiveSelection: false,
                            textInputType: TextInputType.visiblePassword,
                            head: "Password",
                            hint: "Password",
                            controller: _passwordController,
                            visibility: passVisibility,
                            suffix: IconButton(
                              onPressed: (() {
                                passVisibility = !passVisibility;
                                setState(() {});
                              }),
                              icon: Icon(
                                passVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            onChanged: ((pass) {
                              setState(() {});
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputField(
                            enableInteractiveSelection: false,
                            textInputType: TextInputType.visiblePassword,
                            head: "Confirm Password",
                            hint: "Password",
                            controller: _confirmPassController,
                            visibility: confirmPassVisibility,
                            suffix: IconButton(
                              onPressed: (() {
                                confirmPassVisibility = !confirmPassVisibility;
                                setState(() {});
                              }),
                              icon: Icon(
                                confirmPassVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            onChanged: ((pass) {
                              setState(() {});
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            vertical: 15,
                            buttonColor: AppColors.activeButtonColor,
                            textColor: AppColors.white,
                            head: "Sign up",
                            onTap: (() {
                              if (AppConstants.isNameValid(
                                      _nameController.text.trim()) &&
                                  AppConstants.isPasswordValid(
                                      _passwordController.text.trim()) &&
                                  (_passwordController.text.trim() ==
                                      _confirmPassController.text.trim()) &&
                                  emailVerified &&
                                  phoneVerified) {
                                Navigator.pushNamed(
                                  context,
                                  AppKeys.mainScreenRouteKey,
                                  arguments: 0,
                                );
                              } else {
                                log(AppConstants.isNameValid(
                                        _nameController.text.trim())
                                    .toString());
                                log(AppConstants.isPasswordValid(
                                        _passwordController.text.trim())
                                    .toString());
                                log((_passwordController.text.trim() ==
                                        _confirmPassController.text.trim())
                                    .toString());
                                log(emailVerified.toString());
                                log(phoneVerified.toString());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar().authSnackBar(
                                    message: "Enter the fields properly",
                                    context: context,
                                  ),
                                );
                              }
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: AppColors.inactiveTextColor,
                                ),
                              ),
                              TextButton(
                                onPressed: (() {
                                  mode = AppKeys.signInModeKey;
                                  setState(() {});
                                }),
                                child: Center(
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (mode == AppKeys.signInModeKey)
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "H",
                            style: GoogleFonts.ptSerif(
                              color: AppColors.secondaryText,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Homies".toUpperCase(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: "Email",
                              ),
                              Tab(
                                text: "Phone",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                InputTextFormField(
                                  textInputType: TextInputType.emailAddress,
                                  hint: "example@achivie.com",
                                  controller: _emailController,
                                  onChanged: ((email) {
                                    setState(() {});
                                  }),
                                ),
                                InputTextFormField(
                                  textInputType: TextInputType.phone,
                                  hint: "E.g 0123456789",
                                  controller: _phoneNumberController,
                                  prefix: CountryCodePicker(
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
                                      setState(() {});
                                    }),
                                    initialSelection: 'IN',
                                  ),
                                  onChanged: ((phone) {
                                    setState(() {});
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputField(
                            enableInteractiveSelection: false,
                            textInputType: TextInputType.visiblePassword,
                            head: "Password",
                            hint: "Password",
                            controller: _passwordController,
                            visibility: passVisibility,
                            suffix: IconButton(
                              onPressed: (() {
                                passVisibility = !passVisibility;
                                setState(() {});
                              }),
                              icon: Icon(
                                passVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            onChanged: ((pass) {
                              setState(() {});
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            vertical: 15,
                            buttonColor: AppColors.activeButtonColor,
                            textColor: AppColors.white,
                            head: "Sign in",
                            onTap: (() {
                              if ((AppConstants.isEmailValid(
                                          _emailController.text.trim()) ||
                                      AppConstants.isPhoneValid(
                                          isoCode,
                                          _phoneNumberController.text
                                              .trim())) &&
                                  _passwordController.text.trim().isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  AppKeys.mainScreenRouteKey,
                                  arguments: 0,
                                );
                              } else {
                                log(AppConstants.isEmailValid(
                                        _emailController.text.trim())
                                    .toString());
                                log(AppConstants.isPhoneValid(isoCode,
                                        _phoneNumberController.text.trim())
                                    .toString());
                                log(_passwordController.text
                                    .trim()
                                    .isNotEmpty
                                    .toString());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar().authSnackBar(
                                    message: "Enter the fields properly",
                                    context: context,
                                  ),
                                );
                              }
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: AppColors.inactiveTextColor,
                                ),
                              ),
                              TextButton(
                                onPressed: (() {
                                  mode = AppKeys.signUpModeKey;
                                  setState(() {});
                                }),
                                child: Center(
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PinVerificationField extends StatelessWidget {
  const PinVerificationField({
    super.key,
    required this.remainingTime,
    required this.onCompleted,
    required this.message,
    required this.onTap,
  });

  final int remainingTime;
  final ValueChanged<String> onCompleted;
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.green,
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mainColor,
                  ),
                ),
                if (remainingTime < 10 || remainingTime != 10)
                  Text(
                    "Resend(${10 - remainingTime}s)",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (remainingTime == 10)
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Otp Field",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.mainColor,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Pinput(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          length: 5,
          pinAnimationType: PinAnimationType.scale,
          defaultPinTheme: PinTheme(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.inactiveDotColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 45,
            height: 45,
            textStyle: TextStyle(
              color: AppColors.white,
            ),
            decoration: BoxDecoration(
              color: AppColors.activeButtonColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          followingPinTheme: PinTheme(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.activeDotColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onCompleted: onCompleted,
        ),
      ],
    );
  }
}

class VerifiedDisplayField extends StatelessWidget {
  const VerifiedDisplayField({
    super.key,
    required this.text,
    required this.onTap,
    required this.btnText,
    required this.head,
  });

  final VoidCallback onTap;
  final String btnText, head, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(alignment: Alignment.centerLeft, child: HeadText(head: head)),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 15,
                    letterSpacing: 1.5,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.green,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.activeButtonColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.activeButtonColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                btnText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.head,
    required this.hint,
    required this.controller,
    this.validator,
    required this.textInputType,
    this.suffix,
    this.prefix,
    this.visibility,
    this.onChanged,
    this.enableInteractiveSelection,
  });

  final String head, hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool? visibility, enableInteractiveSelection;
  final ValueChanged<String>? onChanged;
  final Widget? prefix, suffix;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadText(
          head: widget.head,
        ),
        const SizedBox(
          height: 10,
        ),
        InputTextFormField(
          enableInteractiveSelection: widget.enableInteractiveSelection,
          controller: widget.controller,
          textInputType: widget.textInputType,
          hint: widget.hint,
          suffix: widget.suffix,
          prefix: widget.prefix,
          obscure: widget.visibility,
        ),
      ],
    );
  }
}

class InputTextFormField extends StatelessWidget {
  const InputTextFormField({
    super.key,
    this.enableInteractiveSelection,
    required this.controller,
    required this.textInputType,
    this.validator,
    this.obscure,
    this.onChanged,
    required this.hint,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.focusNode,
    this.fillColor,
    this.contentPadding,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.border,
    this.textColor,
    this.minLines,
    this.maxLines,
    this.autoFocus,
  });

  final bool? obscure, enableInteractiveSelection;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String hint;
  final Widget? prefix, suffix;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Color? fillColor, textColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? enabledBorder,
      focusedBorder,
      errorBorder,
      focusedErrorBorder,
      border;
  final int? minLines, maxLines;
  final bool? autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus ?? false,
      focusNode: focusNode,
      enableInteractiveSelection: enableInteractiveSelection,
      controller: controller,
      minLines: minLines,
      style: TextStyle(
        color: textColor ?? AppColors.mainColor,
        fontSize: 15,
        letterSpacing: 1.5,
      ),
      textInputAction: textInputAction,
      keyboardType: textInputType,
      validator: validator,
      onChanged: onChanged,
      obscureText: textInputType == TextInputType.visiblePassword
          ? obscure ?? false
          : false,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w600,
        ),
        focusColor: AppColors.activeButtonColor,
        border: border ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.white,
              ),
            ),
        enabledBorder: enabledBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.white,
              ),
            ),
        focusedBorder: focusedBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.mainColor,
              ),
            ),
        errorBorder: errorBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.red,
              ),
            ),
        focusedErrorBorder: focusedBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              borderSide: BorderSide(
                color: AppColors.red,
              ),
            ),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor ?? AppColors.textFieldColor,
        isDense: true,
      ),
    );
  }
}

class HeadText extends StatelessWidget {
  const HeadText({
    super.key,
    required this.head,
  });

  final String head;

  @override
  Widget build(BuildContext context) {
    return Text(
      head,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.mainColor,
      ),
    );
  }
}

class CustomSnackbar {
  SnackBar authSnackBar({
    required String message,
    required BuildContext context,
  }) {
    return SnackBar(
      margin: EdgeInsets.only(
        bottom: 30,
        left: MediaQuery.of(context).size.width / 10,
        right: MediaQuery.of(context).size.width / 10,
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: AppColors.activeButtonColor,
      content: Text(
        message,
      ),
    );
  }
}
