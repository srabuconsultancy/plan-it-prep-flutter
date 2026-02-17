import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core.dart';

class MyDailyMeals extends StatelessWidget {
  const MyDailyMeals({super.key});

  @override
  Widget build(BuildContext context) {
    // //print("MealPlanService.to.myMeal.value!.meals!.isEmpty ${MealPlanService.to.myMeal.value!.meals!.isEmpty} ${MealPlanService.to.myMeal.value}");
    return PopScope(
      canPop: true, // Allow default pop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          MealPlanService.to.myMealPlanPage.value = false; // Update service state
        }
      },
      child: SizedBox(
        width: Get.width,
        height: !(RootService.to.isFeatureAccessible) ? Get.height : Get.height - 120,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      AppBarWidget(
                        title: 'Track My Daily Meal'.tr,
                        onTap: () {
                          MealPlanService.to.myMealPlanPage.value = false;
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
                          Get.back();
                        },
                      ),
                      const SizedBox(height: 15),
                      // const DatePickerWidget(),
                      DateSelector(
                        selectedDate: DateTime.now(),
                        totalDays: 7,
                        onDateSelected: (date) async {
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
                        () => MealPlanService.to.myMeal.value.meals.isNotEmpty
                            ? SizedBox(
                                height: Get.height - 250,
                                child: MealPlanListWidget(mealPlan: MealPlanService.to.myMeal.value, isMyDailyMeal: true),
                              ).pSymmetric(h: 5)
                            : MealPlanService.to.myMeal.value.meals.isEmpty
                                ? Center(
                                    child: SizedBox(
                                      width: Get.width,
                                      height: Get.height - ((RootService.to.isFeatureAccessible) ? 250 : 290),
                                      child: "No Entries Found".text.make().centered(),
                                    ),
                                  )
                                : ShimmerLoading(
                                    isLoading: MealPlanService.to.myMeal.value.meals.isEmpty,
                                    child: MealPlanListWidget(
                                      mealPlan: MealPlanService.to.myMeal.value,
                                    ),
                                  ),
                      ),
                    ],
                  ).pSymmetric(h: 15),
                ),
                AnimatedPositioned(
                  duration: 1000.ms,
                  bottom: MealPlanService.to.myMealPlanPageIsAtBottom.value ? ((RootService.to.isFeatureAccessible) ? 150 : 170) : ((RootService.to.isFeatureAccessible) ? 20 : 40), //
                  // Adjust position when at bottom
                  // left: 0,
                  right: MealPlanService.to.myMealPlanPageIsAtBottom.value ? Get.width - 80 : 20,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: glLightThemeColor,
                      tooltip: 'Add Meals'.tr,
                      onPressed: () async {
                        //print("Add Meals");
                        DashboardController dashboardController = Get.find();
                        dashboardController.openAddFoodBottomPanel();
                      },
                      child: Icon(
                        Icons.add_circle,
                        size: 35,
                        color: glAccentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
