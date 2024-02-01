import 'package:flutter/material.dart';
import 'package:homies/screens/auth_screen.dart';
import 'package:homies/screens/search_screen.dart';
import 'package:homies/styles.dart';
import 'package:price_converter/price_converter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/discount_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedPeriodType = 1, selectedPeriod = 1, personCount = 1;
  late TextEditingController _couponTextController;
  bool isDiscountExpanded = false;
  List<Discount> discountList = [];
  double roomPrice = 2000;
  late Razorpay _razorpay;

  @override
  void initState() {
    _couponTextController = TextEditingController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    if (selectedPeriodType == 1 && selectedPeriod == 1) {
      discountList.add(Discount(
          id: "id", type: DiscountType.period, amount: roomPrice * 0.1));
    }

    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  String selectPeriodType(int type, int period) {
    switch (type) {
      case 0:
        if (period <= 1) {
          return "$period day";
        } else {
          return "$period days";
        }
      case 1:
        if (period <= 1) {
          return "$period month";
        } else {
          return "$period months";
        }
      case 2:
        if (period <= 1) {
          return "$period year";
        } else {
          return "$period years";
        }
      default:
        if (period <= 1) {
          return "$period day";
        } else {
          return "$period days";
        }
    }
  }

  double discountedAmount(List<Discount> list) {
    double discountPrice = 0;
    for (Discount val in list) {
      discountPrice += val.amount;
    }
    return discountPrice;
  }

  String discountedAmountString(List<Discount> list) {
    return "${PriceConverter.getFormattedPrice(currency: "₹", price: discountedAmount(list))}/-";
  }

  bool hasDiscount(List<Discount> discounts, DiscountType type) {
    return discounts.any((discount) => discount.type == type);
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input; // Return the input string if it's empty
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: (() {
          var options = {
            'key': 'rzp_test_S1kR3jV8HSCwFT',
            'amount': roomPrice, //in the smallest currency sub-unit.
            'name': 'Rupam Karmakar',
            'external': {
              'wallets': ['paytm'],
            },
            'order_id':
                'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
            'description': widget.uid,
            'timeout': 60, // in seconds
            'prefill': {
              'contact': '9000090000',
              'email': 'gaurav.kumar@example.com'
            }
          };

          _razorpay.open(options);
        }),
        child: Container(
          height: 65,
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.activeButtonColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "Book now",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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
              "Booking",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Payment Details",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 5,
              ),
              child: Column(
                children: [
                  BookingDetailsRow(
                    item: 'Price',
                    price:
                        "${PriceConverter.getFormattedPrice(currency: "₹", price: roomPrice - discountedAmount(discountList))}/-",
                  ),
                  BookingDetailsRow(
                    item: 'Booking Period',
                    price: selectPeriodType(selectedPeriodType, selectedPeriod),
                  ),
                  BookingDetailsRow(
                    item: 'Person',
                    price: personCount.toString(),
                  ),
                  if (discountList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (() {
                              isDiscountExpanded = !isDiscountExpanded;
                              setState(() {});
                            }),
                            child: Row(
                              children: [
                                Text(
                                  "${discountList.length == 1 ? "Discount" : "Discounts"} (${discountList.length})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.activeButtonColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  isDiscountExpanded
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded,
                                  color: AppColors.activeButtonColor,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            discountedAmountString(discountList),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isDiscountExpanded && discountList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: discountList
                            .map((e) => BookingDetailsRow(
                                  item: capitalizeFirstLetter(e.type.name),
                                  price:
                                      "${PriceConverter.getFormattedPrice(currency: "₹", price: e.amount)}/-",
                                ))
                            .toList(),
                      ),
                    ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                    ),
                  ),
                  BookingDetailsRow(
                    item: 'Total Amount',
                    itemTextColor: AppColors.mainColor,
                    price: personCount.toString(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Booking Date",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 10,
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 15,
              ),
              decoration: BoxDecoration(
                color: AppColors.inactiveDotColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.mainColor,
                  ),
                  Text(
                    DateTime.now().toString(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Booking Period",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
              child: Row(
                children: [
                  BookingPeriodContainer(
                    onTap: (() {
                      if (selectedPeriod == 1 && selectedPeriodType == 1) {
                        selectedPeriod = 29;
                        selectedPeriodType = 0;
                        discountList.removeWhere(
                            (element) => element.type == DiscountType.period);
                        setState(() {});
                      } else if (selectedPeriod == 1 &&
                          selectedPeriodType == 2) {
                        selectedPeriod = 11;
                        selectedPeriodType = 1;
                        setState(() {});
                      } else if (selectedPeriod >= 2) {
                        selectedPeriod--;
                        setState(() {});
                      }
                    }),
                    containerColor: AppColors.inactiveDotColor,
                    widget: Icon(
                      Icons.remove,
                      color: (selectedPeriod != 0)
                          ? AppColors.mainColor
                          : AppColors.mainColor.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BookingPeriodContainer(
                      containerColor: AppColors.inactiveDotColor,
                      widget: Center(
                        child: Text(
                          selectedPeriod.toString(),
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BookingPeriodContainer(
                    onTap: (() {
                      if (selectedPeriod == 29 && selectedPeriodType == 0) {
                        selectedPeriod = 1;
                        selectedPeriodType = 1;
                        discountList.add(
                          Discount(
                            id: "id",
                            type: DiscountType.period,
                            amount: roomPrice * 0.1,
                          ),
                        );
                        setState(() {});
                      } else if (selectedPeriod == 11 &&
                          selectedPeriodType == 1) {
                        selectedPeriod = 1;
                        selectedPeriodType = 2;
                        setState(() {});
                      } else {
                        selectedPeriod++;
                        setState(() {});
                      }
                    }),
                    containerColor: AppColors.inactiveDotColor,
                    widget: Icon(
                      Icons.add,
                      color: AppColors.mainColor,
                    ),
                  ),
                ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BookingPeriodTypeContainer(
                      onTap: (() {
                        selectedPeriodType = 0;
                        selectedPeriod = 1;
                        setState(() {});
                      }),
                      label: 'Days',
                      containerColor: selectedPeriodType == 0
                          ? AppColors.activeButtonColor
                          : AppColors.inactiveDotColor,
                      textColor: selectedPeriodType == 0
                          ? AppColors.white
                          : AppColors.mainColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BookingPeriodTypeContainer(
                      onTap: (() {
                        selectedPeriodType = 1;
                        selectedPeriod = 1;
                        if (!hasDiscount(discountList, DiscountType.period)) {
                          discountList.add(Discount(
                              id: "id",
                              type: DiscountType.period,
                              amount: roomPrice * 0.05));
                        }
                        setState(() {});
                      }),
                      label: 'Months',
                      containerColor: selectedPeriodType == 1
                          ? AppColors.activeButtonColor
                          : AppColors.inactiveDotColor,
                      textColor: selectedPeriodType == 1
                          ? AppColors.white
                          : AppColors.mainColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BookingPeriodTypeContainer(
                      onTap: (() {
                        selectedPeriodType = 2;
                        selectedPeriod = 1;

                        setState(() {});
                      }),
                      label: 'Years',
                      containerColor: selectedPeriodType == 2
                          ? AppColors.activeButtonColor
                          : AppColors.inactiveDotColor,
                      textColor: selectedPeriodType == 2
                          ? AppColors.white
                          : AppColors.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Number of Person",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
              child: Row(
                children: [
                  BookingPeriodContainer(
                    onTap: (() {
                      if (personCount != 1) {
                        personCount--;
                        if (personCount == 1) {
                          discountList.removeWhere(
                              (element) => element.type == DiscountType.person);
                        }
                        setState(() {});
                      }
                    }),
                    containerColor: AppColors.inactiveDotColor,
                    widget: Icon(
                      Icons.remove,
                      color: (personCount != 0)
                          ? AppColors.mainColor
                          : AppColors.mainColor.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BookingPeriodContainer(
                      containerColor: AppColors.inactiveDotColor,
                      widget: Center(
                        child: Text(
                          personCount.toString(),
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BookingPeriodContainer(
                    onTap: (() {
                      if (personCount != 5) {
                        personCount++;
                        if (personCount == 2 &&
                            !hasDiscount(discountList, DiscountType.person)) {
                          discountList.add(
                            Discount(
                              id: "id",
                              type: DiscountType.person,
                              amount: roomPrice * 0.1,
                            ),
                          );
                        }
                        setState(() {});
                      }
                    }),
                    containerColor: AppColors.inactiveDotColor,
                    widget: Icon(
                      Icons.add,
                      color: (personCount != 5)
                          ? AppColors.mainColor
                          : AppColors.mainColor.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!hasDiscount(discountList, DiscountType.coupon))
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add coupon",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: (() {}),
                      child: Text(
                        "Browse coupons",
                        style: TextStyle(
                          color: AppColors.activeButtonColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!hasDiscount(discountList, DiscountType.coupon))
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputTextFormField(
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                          bottom: 10,
                        ),
                        controller: _couponTextController,
                        textInputType: TextInputType.text,
                        hint: "Your coupon",
                        fillColor: AppColors.inactiveSliderColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: (() {}),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inactiveDotColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: AppColors.activeButtonColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

class BookingDetailsRow extends StatelessWidget {
  const BookingDetailsRow({
    super.key,
    required this.item,
    required this.price,
    this.itemTextColor,
  });

  final String item;
  final String price;
  final Color? itemTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: itemTextColor ?? AppColors.inactiveTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingPeriodTypeContainer extends StatelessWidget {
  const BookingPeriodTypeContainer({
    super.key,
    required this.onTap,
    required this.label,
    required this.containerColor,
    required this.textColor,
    this.height,
  });

  final VoidCallback onTap;
  final String label;
  final Color containerColor, textColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: height ?? 45,
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BookingPeriodContainer extends StatelessWidget {
  const BookingPeriodContainer({
    super.key,
    this.onTap,
    required this.containerColor,
    this.widget,
    this.height,
  });

  final VoidCallback? onTap;
  final Widget? widget;
  final Color containerColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: height ?? 45,
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: widget,
      ),
    );
  }
}
