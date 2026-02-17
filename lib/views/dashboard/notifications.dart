import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core.dart';

class NotificationsView extends StatefulWidget {
  final int type;
  final int userId;
  const NotificationsView({super.key, this.type = 0, this.userId = 0});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  UserController userController = Get.find();
  DashboardService dashboardService = Get.find();
  DashboardController dashboardController = Get.find();
  UserService userService = Get.find();
  @override
  void initState() {
    userController.page = 1;
    userController.fetchNotificationsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Get.theme.primaryColor, statusBarIconBrightness: Brightness.light),
    );
    return PopScope(
      canPop: true, // Allow default pop
      onPopInvokedWithResult: (didPop, result) {
        // No additional logic needed, as default pop is allowed
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: Get.theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            title: "Notifications".tr.text.uppercase.bold.size(18).color(glLightIconColor).make(),
            centerTitle: true,
          ),
          body: SafeArea(
            child: !userController.showLoader.value
                ? Obx(() {
                    return Container(
                      width: Get.width,
                      color: Get.theme.primaryColor,
                      child: userService.notifications.isNotEmpty
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                if (scrollNotification is ScrollUpdateNotification) {
                                  //print(
                                  //     "scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent ${scrollNotification.metrics.pixels} == ${scrollNotification.metrics.maxScrollExtent}");
                                  // Check if the list is scrolled to the bottom
                                  if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
                                    userController.page = userController.page + 1;
                                    userController.fetchNotificationsList(); // List has reached the bottom
                                  }
                                }

                                return true;
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: userService.notifications.length,
                                itemBuilder: (context, index) {
                                  final item = UserService.to.notifications.elementAt(index);
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: ListTile(
                                      onTap: () {
                                        userController.notificationAction(item);
                                      },
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                      dense: true,
                                      title: Text(
                                        item.title,
                                        style: TextStyle(
                                          color: glLightIconColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        Helper.timeAgoSinceDate(item.createdAt),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: glLightIconColor.withValues(alpha: 0.7),
                                          fontSize: 13,
                                        ),
                                      ),
                                      trailing: Transform.translate(
                                        offset: const Offset(0, -20),
                                        child: item.pageName == "water"
                                            ? SizedBox(
                                                width: 70,
                                                height: 100,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                      'assets/lottie/medium-water-bottle.json',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(
                                                width: 70,
                                                height: 100,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Lottie.asset(
                                                      'assets/lottie/food-alarm.json',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ).paddingAll(5),
                                  );
                                },
                              ),
                            )
                          : Container(
                              color: Get.theme.primaryColor,
                              height: Get.height,
                              width: Get.width,
                              child: Center(
                                child: Text(
                                  "There is no notification yet!".tr,
                                  style: TextStyle(
                                    color: glLightIconColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                    );
                  })
                : const SizedBox(
                    height: 0,
                  ),
          ),
        );
      }),
    );
  }
}
