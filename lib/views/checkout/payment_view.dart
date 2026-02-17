// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core.dart';

class PaymentView extends GetView<PackageController> {
  PaymentView({super.key});

  final PackageService packageService = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: glLightPrimaryColor, statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      backgroundColor: glLightPrimaryColor,
      appBar: AppBar(
        surfaceTintColor: glLightPrimaryColor,
        shadowColor: glLightPrimaryColor,
        foregroundColor: glLightPrimaryColor,
        backgroundColor: glLightPrimaryColor,
        centerTitle: false,
        leadingWidth: 0,
        bottomOpacity: 1,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        excludeHeaderSemantics: true,
        title: AppBarWidget(
          height: 60,
          title: "Checkout",
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: glLightPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: glLightIconColor.withValues(alpha: 0.09),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: ["Package: ".text.bold.size(20).make(), "${packageService.currentPackage.value.title!} Diet Plan".text.size(20).make()],
                          ).pSymmetric(h: 20, v: 10),
                          ListTile(
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            horizontalTitleGap: 5,
                            enabled: true,
                            minVerticalPadding: 0,
                            leading: Icon(Icons.price_check, color: glLightIconColor.withValues(alpha: 0.7), size: 20),
                            title: SizedBox(
                              width: 75,
                              child: FittedBox(
                                child: "Price".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                              ),
                            ),
                            trailing: packageService.currentPackage.value.price! > packageService.currentPackage.value.discountedPrice!
                                ? SizedBox(
                                    width: Get.width / 1.6,
                                    child: Row(
                                      children: [
                                        ("₹${packageService.currentPackage.value.price!}")
                                            .text
                                            .lineThrough
                                            .textStyle(
                                              Get.theme.textTheme.headlineSmall!.copyWith(
                                                color: glLightIconColor.withValues(alpha: 0.6),
                                                fontSize: 13,
                                              ),
                                            )
                                            .make()
                                            .pOnly(right: 5),
                                        ("₹${packageService.currentPackage.value.discountedPrice!}")
                                            .text
                                            .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 13))
                                            .make()
                                      ],
                                    ).pSymmetric(h: 5),
                                  )
                                : ("₹${packageService.currentPackage.value.price!}")
                                    .text
                                    .lineThrough
                                    .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 13))
                                    .make(),
                          ).pSymmetric(h: 5),
                        ],
                      ),
                      packageService.appliedCouponValue.value.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Get.theme.dividerColor, thickness: 0.7).pOnly(left: 53, right: 20),
                                ListTile(
                                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                  horizontalTitleGap: 5,
                                  enabled: true,
                                  minVerticalPadding: 0,
                                  leading: Icon(Icons.discount, color: glLightIconColor.withValues(alpha: 0.7), size: 20),
                                  title: "Discount".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                                  trailing: "- ${Helper.calculateDiscountAmount()}".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 13)).make(),
                                ).pSymmetric(h: 5),
                              ],
                            )
                          : const SizedBox(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: Get.theme.dividerColor, thickness: 0.7).pOnly(left: 53, right: 20),
                          ListTile(
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            horizontalTitleGap: 5,
                            enabled: true,
                            minVerticalPadding: 0,
                            leading: Icon(Icons.sticky_note_2_outlined, color: glLightIconColor.withValues(alpha: 0.7), size: 20),
                            title: "Total Amount".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                            trailing: "₹${Helper.calculateDiscountedAmount()}".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 13)).make(),
                          ).pSymmetric(h: 5),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ).pSymmetric(v: 15),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: glLightPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: glLightIconColor.withValues(alpha: 0.03),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              packageService.appliedCouponValue.value.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                packageService.couponCode.value.text.uppercase
                                                    .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: Get.theme.colorScheme.primary, fontSize: 14))
                                                    .make()
                                                    .pOnly(right: 5),
                                                "applied".text.textStyle(Get.theme.textTheme.bodySmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                                              ],
                                            ).pOnly(bottom: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 18,
                                                ).pOnly(right: 5),
                                                "${Helper.calculateDiscountAmount()}"
                                                    .text
                                                    .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 14))
                                                    .make()
                                                    .pOnly(right: 5),
                                                "coupon savings".text.textStyle(Get.theme.textTheme.bodySmall!.copyWith(color: glLightIconColor.withValues(alpha: 0.8), fontSize: 13)).make(),
                                              ],
                                            ).pOnly(bottom: 5, left: 2),
                                          ],
                                        ),
                                        "Remove".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: Get.theme.colorScheme.primary, fontSize: 12)).make().onTap(() {
                                          packageService.couponCode.value = "";
                                          packageService.appliedCouponType = "";
                                          packageService.appliedCouponValue.value = "";
                                        }),
                                      ],
                                    ).pSymmetric(h: 15)
                                  : Row(
                                      children: [
                                        Icon(
                                          Icons.discount,
                                          color: glLightIconColor.withValues(alpha: 0.7),
                                          size: 18,
                                        ).pOnly(right: 5),
                                        "Apply Coupon".text.textStyle(Get.theme.textTheme.headlineSmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                                      ],
                                    ).pSymmetric(h: 15).pOnly(bottom: 15),
                              if (packageService.appliedCouponValue.value.isEmpty)
                                GestureDetector(
                                  onTap: () {
                                    packageService.appliedCouponValue.value = "";
                                    packageService.appliedCouponValue.refresh();
                                    UserController userController = Get.find();
                                    userController.getMyCoupons();
                                    showModalBottomSheet<void>(
                                        isDismissible: true,
                                        isScrollControlled: true,
                                        barrierColor: Colors.black38,
                                        context: Get.context!,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                            return Obx(
                                              () => Stack(
                                                children: [
                                                  Container(
                                                    color: glLightPrimaryColor,
                                                    width: Get.width,
                                                    height: Get.height * 0.8,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 15),
                                                        "Apply Coupon"
                                                            .text
                                                            .textStyle(
                                                              Get.theme.textTheme.headlineSmall!.copyWith(
                                                                color: glLightIconColor,
                                                                fontSize: 15,
                                                              ),
                                                            )
                                                            .make(),
                                                        const SizedBox(height: 12),
                                                        TextFormField(
                                                          style: TextStyle(color: glLightIconColor, fontWeight: FontWeight.w300),
                                                          keyboardType: TextInputType.text,
                                                          onChanged: (input) {
                                                            packageService.couponCode.value = input;
                                                            packageService.couponCode.refresh();
                                                          },
                                                          autocorrect: true,
                                                          decoration: InputDecoration(
                                                            hintText: "Coupon Code".tr,
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                                                            prefixIcon: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons.discount,
                                                                  color: glLightThemeColor,
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Container(
                                                                  height: 35,
                                                                  width: 1,
                                                                  color: glLightIconColor.withValues(alpha: 0.1),
                                                                ),
                                                              ],
                                                            ).pOnly(left: 20, right: 15),
                                                            suffixIcon: "Apply"
                                                                .text
                                                                .uppercase
                                                                .minFontSize(5)
                                                                .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                                                                    color: packageService.couponCode.value.isNotEmpty && packageService.couponCode.value.length > 5
                                                                        ? Get.theme.colorScheme.primary
                                                                        : glLightIconColor.withValues(alpha: 0.5),
                                                                    fontSize: 11))
                                                                .wide
                                                                .make()
                                                                .pOnly(right: 15, top: 18)
                                                                .onTap(() async {
                                                              if (packageService.couponCode.value.isNotEmpty && packageService.couponCode.value.length > 5) {
                                                                Get.backLegacy(closeOverlays: true);
                                                                controller.applyCoupon();
                                                              }
                                                            }),
                                                            errorStyle: const TextStyle(fontSize: 13),
                                                            hintStyle: Get.theme.textTheme.bodyMedium!.copyWith(color: glLightIconColor.withValues(alpha: 0.2)),
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100), borderSide: BorderSide(width: 1, color: glLightIconColor.withValues(alpha: 0.1))),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100), borderSide: BorderSide(width: 1, color: glLightIconColor.withValues(alpha: 0.1))),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100), borderSide: BorderSide(width: 1, color: glLightIconColor.withValues(alpha: 0.1))),
                                                            errorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100), borderSide: BorderSide(width: 1, color: glLightIconColor.withValues(alpha: 0.1))),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(100), borderSide: BorderSide(width: 1, color: glLightIconColor.withValues(alpha: 0.1))),
                                                          ),
                                                        ).pOnly(bottom: 20),
                                                        Expanded(
                                                          child: packageService.activeCouponsData.value.isNotEmpty
                                                              ? ListView.builder(
                                                                  padding: EdgeInsets.only(bottom: packageService.activeCouponsData.value.length > 1 ? 200 : 0),
                                                                  shrinkWrap: true,
                                                                  itemCount: packageService.activeCouponsData.value.length,
                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    CouponItem item = packageService.activeCouponsData.value.elementAt(index);
                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        item.title.text
                                                                            .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                                                                              color: glLightIconColor,
                                                                              fontSize: 15,
                                                                            ))
                                                                            .make()
                                                                            .pOnly(bottom: 10),
                                                                        CouponWidget(
                                                                          isApply: true,
                                                                          item: item,
                                                                          onTap: () {
                                                                            Get.backLegacy(closeOverlays: true);
                                                                            packageService.couponCode.value = item.code;
                                                                            packageService.couponCode.refresh();
                                                                            controller.applyCoupon();
                                                                          },
                                                                        ).pOnly(bottom: 10),
                                                                      ],
                                                                    ).pOnly(bottom: 10, left: 10, right: 10);
                                                                  },
                                                                )
                                                              : SizedBox(
                                                                  child: "You have no coupon"
                                                                      .text
                                                                      .center
                                                                      .textStyle(Get.theme.textTheme.bodySmall!.copyWith(
                                                                        color: glLightIconColor.withValues(alpha: 0.5),
                                                                        fontSize: 15,
                                                                      ))
                                                                      .make()
                                                                      .centered(),
                                                                ),
                                                        ),
                                                      ],
                                                    ).pSymmetric(h: 15),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Transform.translate(
                                                      offset: const Offset(0, -55),
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ).centered(),
                                                      ).centered(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: glLightPrimaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(color: glLightIconColor.withValues(alpha: 0.15), blurRadius: 2),
                                      ],
                                    ),
                                    child: ListTile(
                                      minTileHeight: 45,
                                      dense: true,
                                      contentPadding: const EdgeInsets.only(bottom: 3, top: 0, left: 15, right: 15),
                                      title: "Apply Coupon".text.textStyle(Get.theme.textTheme.bodySmall!.copyWith(color: glLightIconColor, fontSize: 14)).make(),
                                      trailing: Icon(Icons.arrow_forward_ios, size: 15, color: glLightIconColor.withValues(alpha: 0.4)),
                                    ),
                                  ).pOnly(bottom: 5, left: 15, right: 15),
                                )
                              else
                                const SizedBox()
                            ],
                          ).pOnly(top: 15, bottom: 10)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 90,
                ),
              ],
            ).pSymmetric(h: 15),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              // width: Get.width / 1.5,
              // height: 100,
              child: CustomButtonWidget(
                // height: 75,
                border: 1,
                width: Get.width / 1.5,
                borderColor: glLightPrimaryColor,
                bgColor: glLightThemeColor,
                textColor: glLightPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                title: '',
                onTap: () {
                  controller.makePayment(Helper.calculateDiscountedAmount());
                },
                child: Row(
                  children: [
                    "Make Payment ₹${Helper.calculateDiscountedAmount()}"
                        .text
                        .center
                        .textStyle(Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 15, color: glLightPrimaryColor))
                        .make()
                        .centered(),
                    Icon(Icons.arrow_forward_ios, color: glLightPrimaryColor, size: 14),
                  ],
                ),
              ).pSymmetric(h: 15, v: 12),
            ),
            /*Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: controller.controllerCenter,
                  blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                  shouldLoop: true, // start again as soon as the animation is finished
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.red], // manually specify the colors to be used
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
