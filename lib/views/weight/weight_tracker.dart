import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../core.dart';

class WeightTracker extends GetView<DashboardController> {
  const WeightTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        height: 80,
        title: "Weight Tracker",
        onTap: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return controller.getWeightTrackingData();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: Get.width * 0.28,
                            height: Get.width * 0.28,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: Get.width * 0.26,
                                  height: Get.width * 0.26,
                                  alignment: Alignment.center,
                                  child: RoundContainer(
                                    bgColor: glLightestGrey,
                                    size: 60,
                                    child: SvgPicture.asset(
                                      "assets/icons/weighing-machine.svg",
                                      colorFilter: ColorFilter.mode(
                                        glShadeColor,
                                        BlendMode.srcIn,
                                      ),
                                    ).paddingAll(
                                      6,
                                    ),
                                  ),
                                ),
                                /*Obx(() {
                                  //print(
                                      "DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.targetWeight ${(DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.targetWeight) * 100}");
                                  return SimpleCircularProgressBar(
                                    progressStrokeWidth: 10,
                                    backStrokeWidth: 10,
                                    progressColors: glPrimaryGradient,
                                    backColor: glLightGrey,

                                    valueNotifier: ValueNotifier((((DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.targetWeight).abs()) /
                                            ((DashboardService.to.data.value.initialWeight - DashboardService.to.data.value.targetWeight).abs())) *
                                        100),
                                    // valueNotifier: ValueNotifier(50),
                                    startAngle: 180,
                                  );
                                }),*/
                                Obx(() {
                                  final data = DashboardService.to.data.value;
                                  final double initial = data.initialWeight;
                                  final double current = data.currentWeight;
                                  final double target = data.targetWeight;
                                  final double totalDistance = (initial - target).abs();
                                  final double progressMade = (initial - current).abs();
                                  final double percent = totalDistance == 0 ? 0.0 : (progressMade / totalDistance) * 100;

                                  // final double remaining = (totalDistance - progressMade).clamp(0, totalDistance);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SimpleCircularProgressBar(
                                        progressStrokeWidth: 10,
                                        backStrokeWidth: 10,
                                        progressColors: glPrimaryGradient,
                                        backColor: glLightGrey,
                                        valueNotifier: ValueNotifier<double>(percent),
                                        startAngle: 180,
                                      ),
                                      /*const SizedBox(height: 6),
                                      Text(
                                        "${remaining.toStringAsFixed(1)}KG left",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),*/
                                    ],
                                  );
                                })
                              ],
                            ),
                          ),
                        ).marginOnly(right: 15),
                        Obx(
                          () {
                            String text = "";
                            if (DashboardService.to.data.value.currentWeight < DashboardService.to.data.value.targetWeight) {
                              text = " gain ${Helper.formatIfDecimal((DashboardService.to.data.value.targetWeight - DashboardService.to.data.value.currentWeight).abs())} KG";
                            } else if (DashboardService.to.data.value.targetWeight < DashboardService.to.data.value.currentWeight) {
                              text = " lose ${Helper.formatIfDecimal(DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.targetWeight.abs())} KG";
                            } else {}
                            return text != ""
                                ? RichText(
                                    text: TextSpan(
                                      text: 'Your goal is to',
                                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '\n$text',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: glShadeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : "".text.make();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                    child: Icon(
                      CupertinoIcons.square_pencil_fill,
                      size: 30,
                    ),
                  ).onInkTap(() {
                    controller.openUpdateWeightBottomSheet();
                  })
                ],
              ).pSymmetric(v: 10),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Initial Weight".tr.text.bold.size(14).make(),
                    "${DashboardService.to.data.value.initialWeight}".tr.text.size(14).make(),
                  ],
                ).pSymmetric(v: 5),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Current Weight".tr.text.bold.size(14).make(),
                    "${DashboardService.to.data.value.currentWeight}".tr.text.size(14).make(),
                  ],
                ).pSymmetric(v: 5),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Target Weight".tr.text.size(14).bold.make(),
                    "${DashboardService.to.data.value.targetWeight}".tr.text.size(14).make(),
                  ],
                ).pSymmetric(v: 5),
              ),
              const SizedBox(
                height: 20,
              ),
              if (DashboardService.to.weightTrackingData.value.isNotEmpty)
                Obx(
                  () {
                    String goalText = "";
                    if (DashboardService.to.data.value.currentWeight < DashboardService.to.data.value.targetWeight) {
                      goalText = "Gain ${Helper.formatIfDecimal((DashboardService.to.data.value.targetWeight - DashboardService.to.data.value.currentWeight).abs())} KG\nmore";
                    } else if (DashboardService.to.data.value.targetWeight < DashboardService.to.data.value.currentWeight) {
                      goalText = "Lose ${Helper.formatIfDecimal((DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.targetWeight).abs())} KG\nmore";
                    } else {}
                    String progressText = "";
                    if (DashboardService.to.data.value.initialWeight < DashboardService.to.data.value.currentWeight) {
                      progressText = "Gained ${Helper.formatIfDecimal((DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.initialWeight).abs())} KG\ntill now";
                    } else if (DashboardService.to.data.value.currentWeight < DashboardService.to.data.value.initialWeight) {
                      progressText = "Lost ${Helper.formatIfDecimal((DashboardService.to.data.value.currentWeight - DashboardService.to.data.value.initialWeight).abs())} KG\ntill now";
                    } else {
                      progressText = "No Progress\nyet";
                    }
                    return Card(
                      elevation: 10,
                      child: SizedBox(
                        // height: Get.width / 1.3,
                        // height: Get.width / 1.3,
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Analysis".text.size(14).bold.make().paddingSymmetric(vertical: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: glShadeColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      "Target".tr.text.size(12).white.make(),
                                      goalText.tr.text.bold.size(13).center.white.make(),
                                    ],
                                  ).paddingSymmetric(horizontal: 5),
                                  Column(
                                    children: [
                                      "Target Date".tr.text.size(12).white.make(),
                                      (DashboardService.to.data.value.targetDate).tr.text.size(13).bold.white.make(),
                                    ],
                                  ).paddingSymmetric(horizontal: 5),
                                  Column(
                                    children: [
                                      "Progress".tr.text.size(12).white.make(),
                                      progressText.tr.text.center.bold.size(13).white.make(),
                                    ],
                                  ).paddingSymmetric(horizontal: 5),
                                ],
                              ),
                            ).pOnly(
                              bottom: 10,
                            ),
                            Obx(() {
                              List<String> bottomPoints = DashboardService.to.weightTrackingData.value.map((e) => e.date).toList();
                              double minVal = min(DashboardService.to.weightTrackingData.value.first.currentWeight, DashboardService.to.weightTrackingData.value.first.targetWeight);
                              double maxVal = max(DashboardService.to.weightTrackingData.value.first.currentWeight, DashboardService.to.weightTrackingData.value.first.targetWeight);
                              List<double> leftPoints = Helper.generateDoubleList(start: minVal - 3, end: maxVal + 3, interval: 0.5);
                              //print("Length ${DashboardService.to.weightTrackingData.value.length} bottomPoints: $bottomPoints leftPoints:$leftPoints");
                              return WeightTrackerLineChart(
                                bottomPoints: bottomPoints,
                                leftPoints: leftPoints,
                                data: DashboardService.to.weightTrackingData.value,
                                line1Color: glAccentColor,
                                line2Color: glFatColor,
                                betweenColor: glAccentColor.withValues(alpha: 0.3),
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    RoundContainer(
                                      size: 15,
                                      bgColor: glAccentColor,
                                    ).paddingOnly(right: 10),
                                    "Current Weight".text.sm.make(),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    RoundContainer(
                                      size: 15,
                                      bgColor: glFatColor,
                                    ).paddingOnly(right: 10),
                                    "Target Weight".text.sm.make(),
                                  ],
                                ),
                              ],
                            ).pSymmetric(v: 10),
                          ],
                        ).pSymmetric(v: 5, h: 16),
                      ),
                    ).pSymmetric(v: 5);
                  },
                ),
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }
}
