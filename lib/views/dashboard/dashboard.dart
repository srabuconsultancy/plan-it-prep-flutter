import 'dart:ui' as u_i;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as sc;
import 'package:get/get.dart';
import 'package:nutri_ai/controllers/surpriseMealController.dart';
import 'package:nutri_ai/views/calender/calendar_page.dart';
import 'package:nutri_ai/views/dashboard/surPriseMeal2.dart';
import 'package:nutri_ai/views/grocery/grocery_page.dart';

import '../../controllers/calendar_controller.dart';
// --- 1. ADD IMPORT ---
import '../../core.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({super.key});
  final MealPlanController mealPlanController = Get.find();

  @override
  Widget build(BuildContext context) {
    sc.timeDilation = 1.0;
    Get.put(CalendarController());
    // --- 2. PUT THE CONTROLLER ---
    // This makes it available for the button tap
    Get.put(SurpriseMealController());

    return PopScope(
      canPop: controller.onPopScope(),
      onPopInvokedWithResult: controller.handlePopScope,
      child: Scaffold(
        extendBody: true,
        body: Obx(
          () => PageView(
            controller: DashboardService.to.pageController.value,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Home(),
              const CalendarPage(),
              SurpriseMeal(),
              GroceryPage(),
              UserProfile(),
            ],
          ),
        ),
        bottomNavigationBar: bottomBarNav(),
      ),
    );
  }

  // --- WIDGET RE-ARCHITECTED TO USE A STACK ---
  Widget bottomBarNav() {
    return Obx(
      () {
        if (controller.hideBottomBar.value) {
          return const SizedBox.shrink();
        }

        // We MUST use a Stack to allow the floating button to paint
        // *outside* the bounds of the BottomAppBar's ClipRRect.
        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none, // Allow button to overflow upwards
          children: [
            // --- CHILD 1: The Bottom App Bar (without the middle button) ---
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BottomAppBar(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  child: Container(
                    height: 70, // Keep the 70px height
                    child: Directionality(
                      textDirection: u_i.TextDirection.ltr,
                      child: Row(
                        // Use MainAxisAlignment.spaceBetween to
                        // distribute the 4 items + 1 spacer
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // --- Home ---
                          _buildNavItem(
                            label: 'Home',
                            index: 0,
                            inactiveIcon: Icons.home_outlined,
                            activeIcon: Icons.home,
                            onTap: () async {
                              // --- (Kept your exact logic) ---
                              if (!RootService.to.isOnHomePage.value) {
                                RootService.to.isOnHomePage.value = true;
                                DashboardService.to.currentPage.value = 0;
                                DashboardService.to.currentPage.refresh();
                                if (!controller.showHomeLoader.value) {
                                  DashboardService.to.pageController.value
                                      .animateToPage(
                                    DashboardService.to.currentPage.value,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.linear,
                                  );
                                  DashboardService.to.pageController.refresh();
                                }
                              }
                            },
                            showLoader: controller.showHomeLoader.value,
                          ),
                          // --- Calendar ---
                          _buildNavItem(
                            label: 'Calendar',
                            index: 1,
                            inactiveIcon: Icons.calendar_today_outlined,
                            activeIcon: Icons.calendar_today,
                            onTap: () async {
                              // --- (Kept your exact logic) ---
                              DashboardService.to.isOnDashboard.value = true;
                              DashboardService.to.isOnDashboard.refresh();
                              DashboardService.to.currentPage.value = 1;
                              RootService.to.isOnHomePage.value = false;
                              if (RootService.to.isFeatureAccessible) {
                                await mealPlanController.fetchTodayMealPlan();
                              } else {
                                MealPlanService.to.myMealPlanPage.value = true;
                                MealPlanController mealController = Get.find();
                                await mealController.fetchMyMealPlan(
                                    date: MealPlanService
                                        .to.selectedDateForMeal.value);
                              }
                              DashboardService.to.pageController.value
                                  .animateToPage(
                                DashboardService.to.currentPage.value,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                              DashboardService.to.currentPage.refresh();
                              DashboardService.to.pageController.refresh();
                              RootService.to.isOnHomePage.refresh();
                            },
                          ),

                          // --- SPACER for the floating button ---
                          // This leaves a gap in the middle of the app bar
                          const SizedBox(width: 60),

                          // --- Grocery ---
                          _buildNavItem(
                            label: 'Grocery',
                            index: 3,
                            inactiveIcon: Icons.shopping_bag_outlined,
                            activeIcon: Icons.shopping_bag,
                            onTap: () async {
                              // --- (Kept your exact logic) ---
                              await controller.loadDetailedGraphsPage();
                              DashboardService.to.currentPage.value = 3;
                              DashboardService.to.currentPage.refresh();
                              RootService.to.isOnHomePage.value = false;
                              RootService.to.isOnHomePage.refresh();
                              if (UserService
                                      .to.currentUser.value.accessToken !=
                                  '') {
                                DashboardService.to.pageController.value
                                    .animateToPage(
                                  DashboardService.to.currentPage.value,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linear,
                                );
                                DashboardService.to.pageController.refresh();
                              } else {
                                Get.offNamed(Routes.login);
                              }
                            },
                          ),
                          // --- Profile ---
                          _buildNavItem(
                            label: 'Profile',
                            index: 4,
                            inactiveIcon: Icons.person_outline,
                            activeIcon: Icons.person,
                            onTap: () {
                              // --- (Kept your exact logic) ---
                              DashboardService.to.currentPage.value = 4;
                              DashboardService.to.currentPage.refresh();
                              RootService.to.isOnHomePage.value = false;
                              RootService.to.isOnHomePage.refresh();
                              if (UserService
                                      .to.currentUser.value.accessToken !=
                                  '') {
                                DashboardService.to.pageController.value
                                    .animateToPage(
                                  DashboardService.to.currentPage.value,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.linear,
                                );
                                DashboardService.to.pageController.refresh();
                              } else {
                                Get.offNamed(Routes.login);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- CHILD 2: The Floating Button (Positioned on top) ---
            Positioned(
              // The button is ~76px tall (56 button + 4 space + 16 text)
              // The app bar is 70px tall.
              // To lift it by 20px from its "centered" position:
              // (70px bar - 76px button) / 2 = -3px (center)
              // -3px + 20px (lift) = 17px.
              // So we position it 17px from the bottom.
              bottom: 17,
              child: _buildFloatingNavItem(
                label: 'Surprise Me',
                index: 2, // Corresponds to MyDailyMeals()
                svgPath: 'assets/icons/surprisemeal.svg',
                onTap: () {
                  // --- 3. CALL API ON TAP ---
                  // This triggers the API call every single time
                  Get.find<SurpriseMealController>().fetchSurpriseMeal();

                  // --- EXISTING NAVIGATION LOGIC ---
                  DashboardService.to.currentPage.value = 2;
                  DashboardService.to.currentPage.refresh();
                  RootService.to.isOnHomePage.value = false;
                  RootService.to.isOnHomePage.refresh();

                  DashboardService.to.pageController.value.animateToPage(
                    DashboardService.to.currentPage.value,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                  );
                  DashboardService.to.pageController.refresh();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET FOR THE FLOATING BUTTON (SIMPLIFIED) ---
  // This is now just a simple Column, as it's no longer
  Widget _buildFloatingNavItem({
    required String label,
    required int index,
    required VoidCallback onTap,
    required String svgPath,
  }) {
    bool isSelected = DashboardService.to.currentPage.value == index;

    // Color configuration
    // If your nav bar is not white, change Colors.white to your specific nav bar color
    Color backgroundColor = Colors.white;

    // The icon provides the color now (Active color or inactive grey)
    Color iconColor = isSelected ? const Color(0xFFFF6F61) : Colors.grey;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: backgroundColor, // Matches the Nav Bar
              shape: BoxShape.circle,
              // The shadow provides the separation instead of a border
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.15), // Slightly softer shadow
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SvgPicture.asset(
              svgPath,
              width: 28,
              height: 28,
              // Dynamically colors the SVG
              // colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : Colors.grey.withOpacity(0.8),
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required int index,
    required VoidCallback onTap,
    required IconData inactiveIcon,
    required IconData activeIcon,
    bool showLoader = false,
  }) {
    bool isSelected = DashboardService.to.currentPage.value == index;
    Color itemColor =
        isSelected ? Color(0xFF4CAF50) : Colors.grey.withValues(alpha: 0.8);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showLoader
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    height: 30,
                  ).paddingAll(5),
                )
              : Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: 24,
                  color: itemColor,
                ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: itemColor,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
