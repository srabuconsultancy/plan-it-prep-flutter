import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:nutri_ai/controllers/surpriseMealController.dart';
import 'package:nutri_ai/views/dashboard/surPriseMeal2.dart';
import 'package:nutri_ai/views/payment/stripePayment.dart';
// Note: SfCircularChart is not used in this file, so import is removed.

import '../../controllers/calendar_controller.dart';

import '../../core.dart';

class Home extends GetView<CalendarController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    UserService authService = Get.find();
    final CalendarController controller = Get.find<CalendarController>();

    // Put SurpriseMealController
    final SurpriseMealController surpriseController =
        Get.put(SurpriseMealController());

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black12,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
      top: true,
      // child: RefreshIndicator(
      //   onRefresh: () async {
      //     // Pull-to-refresh triggers a normal daily plan refresh
      //     await controller.fetchDataForDate(DateTime.now(), isRefresh: true);
      //   },
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: Get.height * 0.068,
            foregroundColor: Get.theme.highlightColor,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(top: 10),
              collapseMode: CollapseMode.pin,
              expandedTitleScale: 1.2,
              title: SafeArea(
                top: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Obx(
                            () => Container(
                              color: Colors.white,
                              width: 40.0,
                              height: 40.0,
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: authService
                                        .currentUser.value.userDP.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: authService
                                            .currentUser.value.userDP,
                                        width: 30,
                                        height: 30,
                                        placeholder: (context, url) => Center(
                                          child: Lottie.asset(
                                            'assets/lottie/loader.json',
                                            height: 120,
                                          ).paddingAll(10),
                                        ),
                                        fit: BoxFit.fill,
                                        errorWidget: (a, b, c) {
                                          return Image.asset(
                                            "assets/images/logo.jpg",
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        "assets/images/logo.jpg",
                                        width: 30,
                                        height: 30,
                                      ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    color: glLightDividerColor, fontSize: 12),
                              ),
                              Text(
                                UserService.to.currentUser.value.name,
                                style: TextStyle(
                                    color: glDashboardPrimaryDarkColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // --- Grouped Icons Section (Deepened for Clarity) ---
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            Get.toNamed(Routes.notifications);
                          },
                          icon: SvgPicture.asset(
                            "assets/icons/notifications.svg",
                            width: 25,
                            height: 25,
                            fit: BoxFit.fitHeight,
                            // Removed alpha/transparency for a deeper, clearer look
                            colorFilter: const ColorFilter.mode(
                                Colors.black87, BlendMode.srcIn),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            Get.toNamed('/favouriteMealPage');
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 25,
                            // Using a solid deep color for high visibility
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).marginSymmetric(horizontal: 15),
              ),
            ),
          ),
          // Listen to isLoading from CalendarController ONLY
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    height: 120,
                  ).paddingAll(10),
                ),
              );
            }
            // ---
            return SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.width * 0.05,
                      ),

                      // Calorie card
                      if (authService.currentUser.value.dailyCalorieIntake > 0)
                        _buildTodayCaloriesCard(context, controller),

                      // --- REFRESH BUTTON (UPDATED LOGIC) ---
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              HapticFeedback.mediumImpact();

                              //calling the refresh meal api
                              await controller.fetchDataForDate(DateTime.now(),
                                  isRefresh: true);

                              // --- LIMIT CHECK LOGIC ---
                              final box = GetStorage();
                              final todayStr = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());

                              // Get stored data
                              String? storedDate =
                                  box.read('surprise_refresh_date');
                              int refreshCount =
                                  box.read('surprise_refresh_count') ?? 0;

                              // Reset if new day
                              if (storedDate != todayStr) {
                                refreshCount = 0;
                                box.write('surprise_refresh_date', todayStr);
                                box.write('surprise_refresh_count', 0);
                              }

                              //call refresh meal api

                              if (false) {
                                // Limit Reached
                                HapticFeedback.heavyImpact();
                                Get.snackbar(
                                  "Limit Reached",
                                  "You can only refresh the meal 2 times a day.",
                                  snackPosition: SnackPosition.bottom,
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.1),
                                  colorText: Colors.orange[800],
                                  duration: const Duration(seconds: 3),
                                );
                                return;
                              }

                              // Allowed -> Proceed
                              HapticFeedback.mediumImpact();

                              // Increment Count
                              box.write(
                                  'surprise_refresh_count', refreshCount + 1);

                              // 1. Navigate to the SurpriseMeal Page (Full Screen)
                              //Get.to(() => const SurpriseMeal());

                              // 2. Trigger the API call (Logic runs on the new page)
                              surpriseController.fetchSurpriseMeal();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh,
                                      size: 16,
                                      color: glDashboardPrimaryDarkColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Refresh Meal",
                                    style: TextStyle(
                                      color: glDashboardPrimaryDarkColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      // -------------------------------------------------------

                      SizedBox(
                        height: Get.width * 0.02,
                      ),

                      // Map over recipeCards
                      ...controller.recipeCards.map((recipeData) {
                        return _buildMealCard(recipeData: recipeData);
                      }),

                      const SizedBox(height: 20),

                      // Button to Redirect to Grocery Page
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomButtonWidget(
                          title: "Get today's Grocery List",
                          width: double.infinity,
                          height: 64,
                          bgColor: glLightThemeColor,
                          textColor: Colors.white,
                          borderRadius: glBorderRadius,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          onTap: () {
                            DashboardService.to.currentPage.value = 3;
                            RootService.to.isOnHomePage.value = false;

                            DashboardService.to.currentPage.refresh();
                            RootService.to.isOnHomePage.refresh();

                            DashboardService.to.pageController.value
                                .animateToPage(
                              3,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                      SizedBox(
                        height: Get.width * 0.2,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTodayCaloriesCard(
      BuildContext context, CalendarController controller) {
    double totalTargetCalories = 0;
    for (var card in controller.recipeCards) {
      totalTargetCalories +=
          double.tryParse(card.calories.replaceAll(RegExp(r'[^0-9.]'), '')) ??
              0;
    }

    final double target = totalTargetCalories;

    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            glLightThemeColor,
            glLightThemeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(glBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Today's menu is ${Helper.formatIfDecimal(target, decimal: 0)} calories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 100.ms).fadeIn(duration: 1000.ms).slideX();
  }

  Widget _buildMealCard({required RecipeCardData recipeData}) {
    final String mealName = recipeData.day;
    final Color mealColor = mealName == "Breakfast"
        ? Color(0xFFFEEAE6)
        : mealName == "Morning Snack"
            ? Color(0xFFFDF6E3)
            : mealName == "Lunch"
                ? Color(0xFFE8F5E9)
                : mealName == "Evening Snack"
                    ? Color(0xFFFCE4EC)
                    : Color(0xFFE0F7FA);

    final String mealIcon = mealName == "Breakfast"
        ? "assets/icons/breakfast.svg"
        : mealName == "Morning Snack"
            ? "assets/icons/morning-snack.svg"
            : mealName == "Lunch"
                ? "assets/icons/dish.svg"
                : mealName == "Evening Snack"
                    ? "assets/icons/evening-snack.svg"
                    : "assets/icons/supper.svg";

    final CalendarController controller = Get.find<CalendarController>();

    return Obx(() {
      final isExpanded =
          controller.expansionState[recipeData.uniqueKey] ?? false;

      return Card(
        color: Colors.white,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 124,
                  decoration: BoxDecoration(
                    color: mealColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        semanticContainer: true,
                        color: glLightPrimaryColor,
                        child: SizedBox(
                          width: 80,
                          height: 112,
                          child: SvgPicture.asset(mealIcon)
                              .p(mealName == "Breakfast" ? 10 : 5),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    mealName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                recipeData.recipeName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.local_fire_department,
                                          color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        recipeData.calories,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
// --- PROFESSIONAL SOLID HEART BUTTON ---
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Obx(() {
                    final int mealEnum = controller.getMealEnum(mealName);
                    final bool active =
                        controller.favouriteTypeSet.contains(mealEnum);

                    return GestureDetector(
                      onTap: () async {
                        //  INSTANT UI UPDATE (Optimistic)
                        if (active) {
                          controller.favouriteTypeSet.remove(mealEnum);
                        } else {
                          controller.favouriteTypeSet.add(mealEnum);
                        }

                        // CALL API
                        bool success;

                        if (active) {
                          success =
                              await controller.removeFromFavouriteOptimistic(
                                  "diet_plan", mealName, mealEnum);
                        } else {
                          success = await controller.addToFavouriteOptimistic(
                              "diet_plan", mealName, mealEnum);
                        }

                        // REVERT IF FAILED
                        if (!success) {
                          if (active) {
                            controller.favouriteTypeSet.add(mealEnum);
                          } else {
                            controller.favouriteTypeSet.remove(mealEnum);
                          }

                          Get.snackbar("Error", "Failed to update favourite");
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: active
                                  ? Colors.red.withOpacity(0.35)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: active ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: AnimatedScale(
                          scale: active ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            active ? Icons.favorite : Icons.favorite_border,
                            color: active
                                ? const Color(0xFFE91E63)
                                : const Color(0xFF9E9E9E),
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: glLightPrimaryColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        recipeData.prepTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          shadows: [
                            Shadow(
                              color: Colors.white54,
                              offset: Offset(0.5, 0.5),
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Divider(
                        color: Colors.grey.withOpacity(0.15), height: 1),
                  ),
                  InkWell(
                    onTap: () =>
                        controller.toggleCardExpansion(recipeData.uniqueKey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isExpanded ? "Hide Recipe".tr : "Show Recipe".tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: glAccentColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: glAccentColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(height: 0),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        recipeData.recipePoints,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeIn,
                    sizeCurve: Curves.easeInOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
