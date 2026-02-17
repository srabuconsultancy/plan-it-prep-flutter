import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../core.dart';

class DashboardController extends GetxController {
  DateTime currentBackPressTime = DateTime.now();

  final ScrollController homeScrollController = ScrollController();
  Timer? _debounce;

  final Duration _debounceDuration = const Duration(milliseconds: 1000);
  List lastWorkoutArr = [
    {"name": "Full Body Workout", "image": "assets/img/Workout1.png", "kcal": "180", "time": "20", "progress": 0.3},
    {"name": "Lower Body Workout", "image": "assets/img/Workout2.png", "kcal": "200", "time": "30", "progress": 0.4},
    {"name": "Ab Workout", "image": "assets/img/Workout3.png", "kcal": "300", "time": "40", "progress": 0.7},
  ];
  var showingTooltipOnSpots = [21].obs;

  List<FlSpot> get allSpots => const [
        FlSpot(0, 20),
        FlSpot(1, 25),
        FlSpot(2, 40),
        FlSpot(3, 50),
        FlSpot(4, 35),
        FlSpot(5, 40),
        FlSpot(6, 30),
        FlSpot(7, 20),
        FlSpot(8, 25),
        FlSpot(9, 40),
        FlSpot(10, 50),
        FlSpot(11, 35),
        FlSpot(12, 50),
        FlSpot(13, 60),
        FlSpot(14, 40),
        FlSpot(15, 50),
        FlSpot(16, 20),
        FlSpot(17, 25),
        FlSpot(18, 40),
        FlSpot(19, 50),
        FlSpot(20, 35),
        FlSpot(21, 80),
        FlSpot(22, 30),
        FlSpot(23, 20),
        FlSpot(24, 25),
        FlSpot(25, 40),
        FlSpot(26, 50),
        FlSpot(27, 35),
        FlSpot(28, 50),
        FlSpot(29, 60),
        FlSpot(30, 40)
      ];

  List waterArr = [
    {"title": "6pm - 10pm", "subtitle": "900ml"},
    {"title": "4pm - 6pm", "subtitle": "900ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "5am - 8am", "subtitle": "600ml"},
  ];
  List<LineChartBarData> lineBarsData = [];

  LineChartBarData? tooltipsOnBar;

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: glCarbColor,
              value: DashboardService.to.data.value.todayMacros.carb.toDouble(),
              title: DashboardService.to.data.value.todayMacros.carb.toString(),
              titleStyle: const TextStyle(fontSize: 10),
              titlePositionPercentageOffset: 0.55,
              radius: 65,
              /*titlePositionPercentageOffset: 0.55,
              badgeWidget: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        "assets/icons/chicken.svg",
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "20%",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),*/
            );
          case 1:
            return PieChartSectionData(
              color: glProteinColor,
              value: DashboardService.to.data.value.todayMacros.protein.toDouble(),
              title: DashboardService.to.data.value.todayMacros.protein.toString(),
              radius: 65,
              titlePositionPercentageOffset: 0.55,
              titleStyle: const TextStyle(fontSize: 10),
            );
          case 2:
            return PieChartSectionData(
              color: glFatColor,
              value: DashboardService.to.data.value.todayMacros.fat.toDouble(),
              title: DashboardService.to.data.value.todayMacros.fat.toString(),
              radius: 65,
              titleStyle: const TextStyle(fontSize: 10),
              titlePositionPercentageOffset: 0.55,
            );
          case 3:
            return PieChartSectionData(
              color: glFiberColor,
              value: DashboardService.to.data.value.todayMacros.fiber.toDouble(),
              title: DashboardService.to.data.value.todayMacros.fiber.toString(),
              radius: 65,
              titleStyle: const TextStyle(fontSize: 8),
              titlePositionPercentageOffset: 0.75,
            );
          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 => const LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(

            // tooltipBgColor: Colors.blueGrey.withValues(alpha:0.8),
            ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          glSecondaryColor2.withValues(alpha: 0.5),
          glSecondaryColor1.withValues(alpha: 0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 35),
          FlSpot(2, 70),
          FlSpot(3, 40),
          FlSpot(4, 80),
          FlSpot(5, 25),
          FlSpot(6, 70),
          FlSpot(7, 35),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          glSecondaryColor2.withValues(alpha: 0.5),
          glSecondaryColor1.withValues(alpha: 0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: glLightBoxShadowColor,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 2,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0h';
        break;
      case 2:
        text = '2h';
        break;
      case 4:
        text = '4h';
        break;
      case 6:
        text = '6h';
        break;
      case 8:
        text = '8h';
        break;
      case 10:
        text = '10h';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: glLightBoxShadowColor,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  var isGraphChecked = <bool>[true, true, true, true, true, true].obs; // Initially unchecked

  @override
  void onInit() {
    animatedDigitController.value = todayWaterIntake.value;
    // TODO: implement onInit
    lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            glLightThemeColor.withValues(alpha: 0.4),
            glSuccessColor.withValues(alpha: 0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: glPrimaryGradient,
        ),
      ),
    ];
    tooltipsOnBar = lineBarsData[0];
    super.onInit();
  }

  ui.Image? image1;
  ui.Image? image2;
  ui.Image? image3;
  ui.Image? image4;

  var todayWaterIntake = 2.0.obs;
  AnimatedDigitController animatedDigitController = AnimatedDigitController(0.0);

  double dailyMaxWaterQty = 3.0;

  var hideBottomBar = false.obs;

  var showHomeLoader = false.obs;
  DateTime now = DateTime.now();
  String formattedDate = "";

  var carouselIndex = 0.obs;

  var cupsFilled = 0.obs;

  int get totalWater => cupsFilled.value * 300;
  // final int goal = 64;

  void toggleCup(int index) {
    if (index < cupsFilled.value) {
      cupsFilled.value = index;
    } else {
      cupsFilled.value = index + 1;
    }
    DashboardService.to.data.value.todayMacrosConsumed.water = cupsFilled.value * 300;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(_debounceDuration, () async {
      // Place the action that you want to perform after debounce here
      updateWaterIntake();
    });
  }

  // Future<void> getData({String date = "2024-09-28"}) async {
  Future<void> getData({String date = ""}) async {
    //print("getData $date");
    DateFormat('yyyy-MM-dd').format(now);
    var response = await Helper.sendRequestToServer(
      endPoint: 'get-dashboard-data',
      requestData: {"date": date == "" ? DateFormat('yyyy-MM-dd').format(now).toString() : date},
    );
    if (response.statusCode == 200) {
      //print("getData dashboard response success");
      //print(response.body);
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        DashboardService.to.data.value = DashboardData.fromJson(jsonData['data']);
        DashboardService.to.data.refresh();
      } else {
        Helper.showToast(msg: jsonData['msg']);
        // throw  Exception(response.body);
      }
    }
  }

  void populateWeightTrackingWithRange(List<WeightTracking> apiData, String startDate, String endDate) {
    // Generate a list of all dates between startDate and endDate
    List<String> dates = generateDateRange(startDate, endDate);

    // Map the API data by date for faster lookup
    final Map<String, WeightTracking> dataMap = {
      for (var entry in apiData) entry.date: entry,
    };

    // Initialize variables to hold the last known values
    double lastCurrentWeight = 0;
    double lastTargetWeight = 0;

    // Create the complete weight tracking list
    List<WeightTracking> populatedList = dates.map((date) {
      if (dataMap.containsKey(date)) {
        // Update last known values when data exists for the date
        lastCurrentWeight = dataMap[date]!.currentWeight;
        lastTargetWeight = dataMap[date]!.targetWeight;
        return dataMap[date]!;
      } else {
        // Use last known values for missing dates
        return WeightTracking(
          date: date,
          currentWeight: lastCurrentWeight,
          targetWeight: lastTargetWeight,
        );
      }
    }).toList();
    // Update the observable list
    DashboardService.to.weightTrackingData.value = populatedList;
    DashboardService.to.weightTrackingData.refresh();
  }

// Helper function to generate a list of dates between two dates
  List<String> generateDateRange(String startDate, String endDate) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime start = dateFormat.parse(startDate);
    DateTime end = dateFormat.parse(endDate);
    List<String> dates = [];

    for (DateTime date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(const Duration(days: 1))) {
      dates.add(dateFormat.format(date));
    }
    return dates;
  }

  Future<void> getWeightTrackingData({String date = ""}) async {
    //print("getWeightTrackingData $date");
    DateFormat('yyyy-MM-dd').format(now);
    var response = await Helper.sendRequestToServer(
      endPoint: 'fetch-weight-history',
      requestData: {},
    );
    if (response.statusCode == 200) {
      //print("getWeightTrackingData response success");
      //print(response.body);
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        DashboardService.to.weightTrackingData.value = Helper.parseItem(jsonData['data'], WeightTracking.fromJson);
        DashboardService.to.weightTrackingData.refresh();
      } else {
        Helper.showToast(msg: jsonData['msg']);
        // throw  Exception(response.body);
      }
    }
  }

  addWater({String quantity = ""}) {
    DashboardService.to.data.value.todayMacrosConsumed.water += num.parse(quantity);
    updateWaterIntake();
  }

  void decreaseWaterIntake({String quantity = "100"}) {
    // Duration for debounce delay
    DashboardService.to.data.value.todayMacrosConsumed.water -= double.parse(quantity);
    DashboardService.to.data.refresh();
    // Cancel the previous debounce timer if it's active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(_debounceDuration, () async {
      // Place the action that you want to perform after debounce here
      //print('Search query:');
      updateWaterIntake();
    });
  }

  updateWaterIntake({String date = "2024-09-24"}) async {
    //print("updateWaterIntake");

    var value = await Helper.sendRequestToServer(
        endPoint: 'update-water-intake',
        requestData: {
          "quantity": DashboardService.to.data.value.todayMacrosConsumed.water.toString(),
          "date": date == "" ? DateFormat('yyyy-MM-dd').format(now).toString() : date,
        },
        method: "post");

    var response = json.decode(value.body);
    if (response["status"]) {
      DashboardService.to.data.value.todayMacrosConsumed.water = num.parse(response["quantity"].toString());
      DashboardService.to.data.refresh();
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  openUpdateWeightBottomSheet() {
    //print("openUpdateWeightBottomSheet");
    Get.bottomSheet(
        backgroundColor: glLightPrimaryColor,
        Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Edit Weight and Goal".text.bold.make(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      Get.backLegacy(closeOverlays: true);
                    },
                  ),
                ],
              ),
              "If you edit your target weight now, your entire goal tracking resets".text.make().marginOnly(bottom: 20),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/weight-tracking.svg",
                    colorFilter: ColorFilter.mode(
                      glLightThemeColor,
                      BlendMode.srcIn,
                    ),
                    width: 30,
                  ).pOnly(right: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Current Weight".text.medium.make(),
                            DashboardService.to.data.value.currentWeight.text.size(18).bold.make(),
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                          child: Icon(
                            CupertinoIcons.square_pencil_fill,
                            size: 20,
                          ),
                        ).onInkTap(() {
                          openWeightPopUp(type: "cw", value: double.parse(DashboardService.to.data.value.currentWeight.toString()));
                        }),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 20).color(glLightestGrey).cornerRadius(glBorderRadius),
                  )
                ],
              ).marginOnly(bottom: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/weight-tracking.svg",
                    colorFilter: ColorFilter.mode(
                      glLightThemeColor,
                      BlendMode.srcIn,
                    ),
                    width: 30,
                  ).pOnly(right: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Target Weight".text.medium.make(),
                            DashboardService.to.data.value.targetWeight.text.size(18).bold.make(),
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                          child: Icon(
                            CupertinoIcons.square_pencil_fill,
                            size: 20,
                          ),
                        ).onInkTap(() {
                          openWeightPopUp(type: "tw", value: double.parse(DashboardService.to.data.value.targetWeight.toString()));
                        }),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 20).color(glLightestGrey).cornerRadius(glBorderRadius),
                  )
                ],
              ).marginOnly(bottom: 10),
            ],
          ).paddingAll(25),
        ));
  }

  openWeightPopUp({type = "cw", final value = 0.0}) {
    //print("openWeightPopUp");
    double newValue = value;
    var onChangedValue = 50.0.obs;
    onChangedValue.value = newValue;
    onChangedValue.refresh();
    AwesomeDialog(
        width: Get.width,
        context: Get.context!,
        body: Column(
          children: [
            (type == "cw" ? "Update Current Weight" : "Update Target Weight").text.bold.xl.make(),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: "KG"
                      .text
                      .textStyle(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: glDarkPrimaryColor,
                          height: 1,
                          shadows: const [
                            // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                          ],
                        ),
                      )
                      .make(),
                ),
                const SizedBox(
                  width: 50,
                ),
                Flexible(
                  child: "Gm"
                      .text
                      .textStyle(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: glDarkPrimaryColor,
                          height: 1,
                          shadows: const [
                            // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                          ],
                        ),
                      )
                      .make(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => DecimalNumberPicker(
                value: onChangedValue.value,
                minValue: 0,
                haptics: true,
                decimalPlaces: 2,
                maxValue: 150,
                itemHeight: 60,
                selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 45),
                onChanged: (val) {
                  //print("onChanged $val");
                  onChangedValue.value = val;
                  onChangedValue.refresh();
                },
                integerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(glBorderRadius),
                ),
                decimalDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(glBorderRadius),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ).p(25),
        customHeader: SvgPicture.asset(
          "assets/icons/weight-tracking.svg",
          colorFilter: ColorFilter.mode(
            glLightThemeColor,
            BlendMode.srcIn,
          ),
        ),
        onDismissCallback: (v) {
          //print("onDismissCallback");
          if (type == "cw") {
            DashboardService.to.data.value.currentWeight = onChangedValue.value.toDouble();
            updateCurrentWeight();
          } else {
            DashboardService.to.data.value.targetWeight = onChangedValue.value.toDouble();
            updateTargetWeight();
          }

          DashboardService.to.data.refresh();
        }).show();
  }

  updateCurrentWeight({double currentValue = 60.0, double targetValue = 65.0}) async {
    //print("updateWaterIntake");
    var value = await Helper.sendRequestToServer(
      endPoint: 'update-current-weight',
      requestData: {
        "current_value": DashboardService.to.data.value.currentWeight.toString(),
      },
      method: "post",
    );
    var response = json.decode(value.body);
    if (response["status"]) {
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  updateTargetWeight({double currentValue = 60.0, double targetValue = 65.0}) async {
    //print("updateWaterIntake");
    var value = await Helper.sendRequestToServer(
      endPoint: 'update-target-weight',
      requestData: {
        "current_value": DashboardService.to.data.value.currentWeight.toString(),
        "target_value": DashboardService.to.data.value.targetWeight.toString(),
      },
      method: "post",
    );
    var response = json.decode(value.body);
    if (response["status"]) {
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  selectWaterQuantityPopUp() {
    Dialogs.materialDialog(
      color: Colors.white,
      // title: 'Add Water',
      msgAlign: TextAlign.center,
      // msg: 'Select Water Quantity',
      barrierDismissible: true,
      customView: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            "Add Water".text.center.uppercase.bold.make(),
            "Select Water Quantity".text.center.make(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width / 4,
                  height: Get.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/water-glass.json',
                        fit: BoxFit.contain,
                        height: Get.width / 4,
                      ).marginOnly(bottom: 5),
                      "Glass (300ml)".text.sm.center.make(),
                    ],
                  ),
                ).onTap(() {
                  //  Get.back(closeOverlays: true);//Get.backLegacy(closeOverlays: true); Get.back(closeOverlays: true);
                  Get.backLegacy(closeOverlays: true);
                  addWater(quantity: "300");
                }),
                SizedBox(
                  width: Get.width / 4,
                  height: Get.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/medium-water-bottle.json',
                        fit: BoxFit.contain,
                        height: Get.width / 4,
                      ).marginOnly(bottom: 5),
                      "Bottle (500ml)".text.sm.center.make(),
                    ],
                  ),
                ).onTap(() {
                  Get.backLegacy(closeOverlays: true);
                  addWater(quantity: "500");
                }),
                SizedBox(
                  width: Get.width / 4,
                  height: Get.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/1l-water-bottle.json',
                        fit: BoxFit.contain,
                        height: Get.width / 4,
                      ).marginOnly(bottom: 5),
                      "Bottle (1L)".text.sm.center.make(),
                    ],
                  ),
                ).onTap(() {
                  Get.backLegacy(closeOverlays: true); // Get.back(closeOverlays: true);//Get.backLegacy(closeOverlays: true);
                  addWater(quantity: "1000");
                }),
              ],
            ),
          ],
        ),
      ),
      context: Get.context!,
      // isDismissible: true,
      useRootNavigator: true,

      actionsBuilder: (context) => [
        IconsButton(
          onPressed: () {
            //Get.back(closeOverlays: true);
            Get.backLegacy(closeOverlays: true);
          },
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          color: glLightThemeColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  increaseWaterIntake() {
    if (DashboardService.to.data.value.todayMacrosConsumed.water.floor() >= DashboardService.to.data.value.todayMacros.water) {
      return;
    }
    animatedDigitController.addValue(0.1);
    todayWaterIntake.value = todayWaterIntake.value + 0.1;
    todayWaterIntake.refresh();
    //print("todayWaterIntake.value == dailyMaxWaterQty ${todayWaterIntake.value} == $dailyMaxWaterQty ${todayWaterIntake.value}${todayWaterIntake.value.floor()}");
    if (todayWaterIntake.value.floor() == dailyMaxWaterQty) {
      //print("asdasdasdasd");
      Dialogs.bottomMaterialDialog(
        color: Colors.white,
        msg: 'Congratulations, you have reached your water goal today.',
        title: 'Congratulations',
        lottieBuilder: Lottie.asset(
          'assets/lottie/congratulations.json',
          fit: BoxFit.contain,
        ),
        context: Get.context!,
        isDismissible: true,
        useRootNavigator: true,
        actionsBuilder: (context) => [
          IconsButton(
            onPressed: () {
              //Get.back(closeOverlays: true);
              Get.backLegacy(closeOverlays: true);
            },
            text: 'Ok',
            iconData: Icons.done,
            color: glLightThemeColor,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    }
  }

  void openAddFoodBottomPanel() {
    //print("DashboardService.to.data.value.meals1 ${DashboardService.to.data.value.meals.length}");
    Dialogs.bottomMaterialDialog(
      color: Colors.white,
      title: 'Add Food',
      msg: '',
      lottieBuilder: Lottie.asset(
        'assets/lottie/add-food.json',
        fit: BoxFit.contain,
      ),
      customViewPosition: CustomViewPosition.BEFORE_ACTION,
      isScrollControlled: true,
      customView: Column(
        children: DashboardService.to.data.value.meals.map((meal) {
          //print("DashboardService.to.data.value.meals1 ${DashboardService.to.data.value.meals.length}");
          return SizedBox(
            height: Get.width * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      meal.name!.text.fontWeight(FontWeight.w500).make(),
                    ],
                  ),
                  RoundContainer(
                    size: 30,
                    bgColor: glLightPrimaryColor,
                    child: const Icon(
                      CupertinoIcons.add,
                      size: 16,
                    ),
                  ).onInkTap(() {
                    MealPlanController mealPlanController = Get.find();
                    mealPlanController.openFoodListForAddToMeal(meal);
                  }).marginOnly(right: 10),
                ],
              ).marginOnly(top: 10),
            ),
          ).marginOnly(bottom: 20).marginSymmetric(horizontal: 15);
        }).toList(),
      ),
      context: Get.context!,
      isDismissible: true,
      useRootNavigator: true,
      actionsBuilder: (context) => [
        IconsButton(
          onPressed: () {
            //Get.back(closeOverlays: true);
            Get.backLegacy(closeOverlays: true);
          },
          text: 'Close',
          iconData: Icons.close_rounded,
          color: glAccentColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.

    if (args.value is PickerDateRange) {
      DashboardService.to.graphMacrosStartDate.value = DateFormat('yyyy-MM-dd').format(args.value.startDate);
      DashboardService.to.graphMacrosEndDate.value = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      DashboardService.to.graphMacrosStartDate.refresh();
      DashboardService.to.graphMacrosEndDate.refresh();
    }
  }

  void showDateRangePicker() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTimeRange? result = await showDialog<DateTimeRange>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date Range'),
          content: SizedBox(
            width: 300, // Adjust width as needed
            height: 400, // Adjust height as needed
            child: SfDateRangePicker(
              onSelectionChanged: onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                dateFormat.parse(DashboardService.to.graphMacrosStartDate.value),
                dateFormat.parse(DashboardService.to.graphMacrosEndDate.value),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                fetchMacroTrackerData();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      DashboardService.to.graphMacrosStartDate.value = dateFormat.format(result.start);
      DashboardService.to.graphMacrosStartDate.refresh();

      DashboardService.to.graphMacrosEndDate.value = dateFormat.format(result.end);
      DashboardService.to.graphMacrosEndDate.refresh();

      // Do something with the selected date range
      //print('Selected Start Date: ${DashboardService.to.graphMacrosStartDate.value}');
      //print('Selected End Date: ${DashboardService.to.graphMacrosEndDate.value}');
    }
  }

  loadDetailedGraphsPage() async {
    DateTime date = DateTime.now().subtract(
      const Duration(
        days: 7,
      ),
    );

    if (UserService.to.currentUser.value.membershipStartDate != null && UserService.to.currentUser.value.membershipStartDate!.isAfter(date)) {
      DashboardService.to.graphMacrosStartDate.value = DateFormat('yyyy-MM-dd').format(UserService.to.currentUser.value.membershipStartDate!);
    } else {
      DashboardService.to.graphMacrosStartDate.value = DateFormat('yyyy-MM-dd').format(date);
    }
    DashboardService.to.graphMacrosStartDate.refresh();
    await fetchMacroTrackerData();
  }

  List<Macros> generateDefaultMacrosList() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    List<Macros> macrosList = [];
    DateTime startDate = dateFormat.parse(DashboardService.to.graphMacrosStartDate.value);
    // DateTime startDate = dateFormat.parse("2025-07-21");
    DateTime endDate = dateFormat.parse(DashboardService.to.graphMacrosEndDate.value);
    // DateTime endDate = dateFormat.parse("2025-07-28");
    for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      macrosList.add(Macros()..date = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");
    }
    return macrosList;
  }

  fetchMacroTrackerData() async {
    List<Macros> tempMacroData = generateDefaultMacrosList();
    EasyLoading.show(status: "Loading...");
    var response = await Helper.sendRequestToServer(
      endPoint: 'fetch-macro-tracker-data',
      requestData: {
        "start_date": DashboardService.to.graphMacrosStartDate.value.toString(),
        // "start_date": "2025-07-21",
        "end_date": DashboardService.to.graphMacrosEndDate.value.toString(),
        // "end_date": "2025-07-28",
      },
    );
    print("fetch-macro-tracker-data requestData ${DashboardService.to.graphMacrosStartDate.value} ${DashboardService.to.graphMacrosEndDate.value}");
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      //print("getData dashboard response success");
      //print(response.body);
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        print("jsonData['data'] ${UserService.to.currentUser.value.accessToken} ${jsonData['data']} ");
        List<Macros> apiMacros = jsonData['data'] == null ? [] : Helper.parseItem(jsonData['data'], Macros.fromJson);
        updateMacrosFromApi(tempMacroData, apiMacros);
      } else {
        Helper.showToast(msg: jsonData['msg']);
        // throw  Exception(response.body);
      }
    }
  }

  void updateMacrosFromApi(List<Macros> defaultMacros, List<Macros> apiMacros) {
    for (var apiMacro in apiMacros) {
      final index = defaultMacros.indexWhere((macro) => macro.date == apiMacro.date);
      if (index != -1) {
        // Update only the macro for the matching date
        defaultMacros[index] = apiMacro;
      }
    }
    print("defaultMacros $defaultMacros}");
    DashboardService.to.graphMacrosConsumed.value = defaultMacros;
    DashboardService.to.graphMacrosConsumed.refresh();
  }

  bool onPopScope() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
      return false;
    }
    DateTime now = DateTime.now();
    if (DashboardService.to.currentPage.value > 0) {
      DashboardService.to.currentPage.value = 0;
      DashboardService.to.currentPage.refresh();
      try {
        DashboardService.to.pageController.value.animateToPage(DashboardService.to.currentPage.value, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } catch (e) {
        //print("$e,$s");
      }
      return false;
    }
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      Helper.toast("Tap again to exit an app.".tr, glDarkPrimaryColor);
      return false;
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');

      return false;
    }
  }

  handlePopScope(bool didPop, dynamic result) {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    DateTime now = DateTime.now();
    if (DashboardService.to.currentPage.value > 0) {
      DashboardService.to.currentPage.value = 0;
      DashboardService.to.currentPage.refresh();
      DashboardService.to.pageController.value.animateToPage(DashboardService.to.currentPage.value, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Helper.toast("Tap again to exit an app.".tr, glDarkPrimaryColor);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
