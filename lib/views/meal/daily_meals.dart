import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

// import 'package:spflutter_number_picker/spflutter_number_picker.dart';

import '../../core.dart';

class DailyMeals extends StatelessWidget {
  DailyMeals({super.key});
  final isAtBottom = false.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Track Meals',
        child: const Icon(Icons.check),
      ),*/
      body: Obx(
        () => Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification && scrollNotification.metrics == _scrollController.position) {
                  // Check if the list is scrolled to the bottom
                  if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
                    isAtBottom.value = true; // List has reached the bottom
                  } else {
                    isAtBottom.value = false; // List is not at the bottom
                  }
                  isAtBottom.refresh();
                }
                return true;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    AppBarWidget(
                      // title: 'Meal Plan${UserService.to.currentUser.value.membershipStartDate.toString().tr}',
                      title: 'Meal Plan',
                      onTap: () {
                        if (DashboardService.to.isOnDashboard.value) {
                          DashboardService.to.currentPage.value = 0;
                          RootService.to.isOnHomePage.value = true;
                          DashboardService.to.pageController.value.animateToPage(
                            DashboardService.to.currentPage.value,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear,
                          );
                          DashboardService.to.currentPage.refresh();
                          DashboardService.to.pageController.refresh();
                          RootService.to.isOnHomePage.refresh();
                        } else {
                          Get.back();
                        }
                      },
                      actions: [
                        Center(
                          child: FloatingActionButton(
                              backgroundColor: glLightPrimaryColor,
                              tooltip: 'Track Meals'.tr,
                              onPressed: () async {
                                // Handle meal tracking
                                //print("Track Meals tapped");
                                MealPlanService.to.myMealPlanPage.value = true;
                                MealPlanController mealController = Get.find();
                                await mealController.fetchMyMealPlan(date: MealPlanService.to.selectedDateForMeal.value);
                                Get.toNamed(Routes.myMeals);
                              },
                              child: Image.asset("assets/icons/track-meals.png").paddingAll(3)),
                        ),
                      ],
                    ),
                    if (UserService.to.currentUser.value.membershipStartDate != null) ...[
                      const SizedBox(height: 15),
                      // const DatePickerWidget(),
                      DateSelector(
                        selectedDate: DateTime.now(),
                        totalDays: 7,
                        onDateSelected: (date) async {
                          //print("Selected: $date");
                          MealPlanService.to.selectedMealDate.value = date;
                          MealPlanService.to.selectedMealDate.refresh();
                          MealPlanController mealPlanController = Get.find();
                          if (MealPlanService.to.myMealPlanPage.value) {
                            await mealPlanController.fetchMyMealPlan(date: DateFormat("yyyy-MM-dd").format(MealPlanService.to.selectedMealDate.value));
                          } else {
                            await mealPlanController.fetchMealPlan(day: mealPlanController.getDayNumber(DateFormat('EEEE').format(MealPlanService.to.selectedMealDate.value)));
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => MealPlanService.to.mealPlan.value != null && MealPlanService.to.mealPlan.value!.meals.isNotEmpty
                            ? SizedBox(
                                height: Get.height - 200,
                                child: MealPlanListWidget(
                                  mealPlan: MealPlanService.to.mealPlan.value!,
                                ),
                              )
                            : SizedBox(width: Get.width, height: Get.height, child: ShimmerLoading(isLoading: MealPlanService.to.mealPlan.value == null, child: const ShimmerPlaceholder())),
                      ),
                    ] else ...[
                      SizedBox(
                        height: Get.height - 150,
                        width: Get.width,
                        child: (RootService.to.isFeatureAccessible)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "For Custom Meal Plan, you must purchase a diet plan".text.medium.center.make().centered(),
                                  IconsButton(
                                    // padding: EdgeInsets.symmetric(horizontal: Get.width / 4),
                                    onPressed: () async {
                                      Helper.makePhoneCall(RootService.to.config.value.contactNo);
                                      /*PackageController packageController = Get.find();
                                  await packageController.getPackagesAnFeatures();
                                  Get.toNamed(Routes.packages);*/
                                      // Get.toNamed(Routes.checkoutPayment);
                                    },
                                    text: 'Call Now',
                                    iconData: Icons.add_shopping_cart_outlined,
                                    color: glLightThemeColor,
                                    textStyle: const TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ).centered().marginSymmetric(horizontal: Get.width / 4, vertical: 12),
                                ],
                              )
                            : Container(
                                child: "Custom Meal Plan, coming soon".text.medium.center.make().centered(),
                              ),
                      ),
                    ],
                  ],
                ).pSymmetric(h: 15),
              ).pOnly(bottom: 20),
            ),
            /*AnimatedPositioned(
              duration: 1000.ms,
              bottom: isAtBottom.value ? 180 : 30, // Adjust position when at bottom
              // left: 0,
              right: isAtBottom.value ? Get.width - 80 : 20,
              child: Center(
                child: FloatingActionButton(
                    backgroundColor: glLightPrimaryColor,
                    tooltip: 'Track Meals'.tr,
                    onPressed: () async {
                      // Handle meal tracking
                      //print("Track Meals tapped");
                      MealPlanService.to.myMealPlanPage.value = true;
                      MealPlanController mealController = Get.find();
                      await mealController.fetchMyMealPlan(date: MealPlanService.to.selectedDateForMeal.value);
                      Get.toNamed(Routes.myMeals);
                    },
                    child: Image.asset("assets/icons/track-meals.png").paddingAll(3)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
