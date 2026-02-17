import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class AddTest extends StatelessWidget {
  const AddTest({
    required Key key,
    this.onTap,
    this.onCloseIconTap,
    this.onRemoveIconTap,
    this.showCloseIcon = false,
    this.testName,
    this.testDate,
  }) : super(key: key);

  final VoidCallback? onTap;
  final VoidCallback? onCloseIconTap;
  final VoidCallback? onRemoveIconTap;
  final bool showCloseIcon;
  final String? testName;
  final String? testDate;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 150,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // constraints: const BoxConstraints(minHeight: 210),
            decoration: BoxDecoration(
              color: glLightDividerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(glBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: glDarkPrimaryColor.withValues(alpha: 0.01),
                  offset: const Offset(0, 3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset(
                        // testName != null ? "assets/lottie/test-uploaded.json" : "assets/lottie/upload.json",
                        "assets/lottie/upload.json",
                        width: 60,
                      ).pOnly(right: 10),
                      testName == null
                          ? "Upload Test".text.lg.make()
                          : SizedBox(
                              height: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: Get.width / 2.1, child: "$testName".text.lg.ellipsis.make()),
                                  SizedBox(width: 70, child: "$testDate".text.medium.make().fittedBox()),
                                ],
                              ),
                            ),
                    ],
                  ).paddingAll(20),
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 20),
                  child: (testName == null)
                      ? RoundContainer(
                          bgColor: glLightPrimaryColor,
                          size: 35,
                          child: Icon(
                            Icons.add_circle,
                            size: 40,
                            color: glLightThemeColor,
                          ),
                        )
                      : RoundContainer(
                          bgColor: glErrorColor,
                          size: 20,
                          child: Icon(
                            Icons.delete_outline,
                            size: 25,
                            color: glLightPrimaryColor,
                          ).onInkTap(onRemoveIconTap),
                        ),
                ),
              ],
            ),
          ).onInkTap(onTap).pOnly(bottom: 20),
          if (showCloseIcon)
            Positioned(
              right: 0,
              top: 0,
              child: RoundContainer(
                bgColor: glErrorColor,
                size: 25,
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: glLightPrimaryColor,
                ).onInkTap(onCloseIconTap),
              ),
            ),
        ],
      ),
    );
  }
}
