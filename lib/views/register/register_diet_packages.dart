import 'dart:async';
import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterDietPackages extends StatefulWidget {
  const RegisterDietPackages({super.key});

  @override
  State<RegisterDietPackages> createState() => _RegisterDietPackagesState();
}

class _RegisterDietPackagesState extends State<RegisterDietPackages> {
  late Timer _timer;
  var autoPlay = true.obs;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: (PackageService.to.packages.value.length * 5) + 1), () {
      autoPlay.value = false;
      autoPlay.refresh();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: ListView(
          children: [
            "Skip"
                .text
                .underline
                .size(12)
                .make()
                .onTap(
                  () {
                    if (DashboardService.to.isOnDashboard.value) {
                      Get.back();
                    } else {
                      DashboardController dashboardController = Get.find();
                      dashboardController.getData();
                      Get.offNamed(Routes.dashboard);
                    }
                  },
                )
                .objectCenterRight()
                .marginOnly(
                  top: 20,
                  right: 20,
                  bottom: 20,
                ),
            Obx(
              () => CarouselSlider(
                options: CarouselOptions(
                  height: Get.height * 0.75,
                  autoPlay: autoPlay.value,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  // enlargeFactor: 0.6,
                ),
                items: PackageService.to.packages.value.mapIndexed((package, index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return _buildPackageCard(package, index);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(Package package, index) {
    Color color = Colors.orangeAccent;
    if (index == 0) {
      color = glLightThemeColor;
    } else if (index == 1) {
      color = Colors.blueAccent;
    } else if (index == 2) {
      color = Colors.black87;
    } else {
      color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1.0);
    }
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image or color
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          // Package content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: package.image!,
                  width: Get.width / 2.2,
                ).centered(),
                SizedBox(
                  height: 40.0,
                  child: Text(
                    package.title!,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const SizedBox(height: 10.0),
                /*SizedBox(
                  height: 40.0,
                  child: Row(
                    children: [
                      Text(
                        '₹${package.price}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ).pOnly(right: 8),
                      Text(
                        '₹${package.discountedPrice}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),*/
                // const SizedBox(height: 20.0),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: PackageService.to.packageFeatures.value.map(
                      (feature) {
                        return ListTile(
                          dense: true,
                          minLeadingWidth: 5,
                          minVerticalPadding: 5,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5),
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          title: Text(
                            feature.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Helper.makePhoneCall(RootService.to.config.value.contactNo);
                    },
                    child: const Text('Call Now'),
                  ).centered(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
