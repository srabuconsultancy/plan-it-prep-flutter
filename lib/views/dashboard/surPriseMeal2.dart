import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutri_ai/controllers/surpriseMealController.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/calendar_controller.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart'; // Import for DateFormat

import '../../core.dart';

class SurpriseMeal extends GetView<SurpriseMealController> {
  const SurpriseMeal({super.key});

  @override
  Widget build(BuildContext context) {
    // Put SurpriseMealController
    final SurpriseMealController surpriseController =
        Get.put(SurpriseMealController());

    // --- MODIFIED: Converted to a normal Scaffold Page ---
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          // onPressed: () => Get.back(),
          onPressed: () {
            /* ... Navigation logic ... */
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
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          "Surprise Meal",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: glDashboardPrimaryDarkColor,
          ),
        ),
      ),
      body: Obx(() {
        // 1. LOADING STATE
        if (controller.isLoading.value) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loader.json',
              height: 120,
            ).paddingAll(10),
          );
        }

        // 2. NO DATA STATE
        if (controller.surpriseMeal.value == null) {
          return const Center(child: Text("No meal data found"));
        }

        // 3. LOADED CONTENT
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Card
              _buildSurpriseMealCard(),

              // --- REFRESH BUTTON DESIGN ---
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 15.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      // 1. Physical Feedback
                      HapticFeedback.mediumImpact();

                      // 2. Logic: Date & Count Management
                      final box = GetStorage();
                      final todayStr =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                      String? storedDate = box.read('surprise_refresh_date');
                      int refreshCount =
                          box.read('surprise_refresh_count') ?? 0;

                      // Reset count if it's a new day
                      if (storedDate != todayStr) {
                        refreshCount = 0;
                        box.write('surprise_refresh_date', todayStr);
                        box.write('surprise_refresh_count', 0);
                      }

                      // 3. Limit Check (e.g., 2 times per day)
                      if (false) {
                        HapticFeedback.heavyImpact();
                        Get.snackbar(
                          "Limit Reached",
                          "You can only refresh the meal 2 times a day.",
                          snackPosition: SnackPosition.bottom,
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          colorText: Colors.orange[800],
                          duration: const Duration(seconds: 3),
                        );
                        return;
                      }

                      // 4. Execution: Trigger API calls
                      await surpriseController.fetchSurpriseMeal(
                          isRefresh: true);

                      // 5. Increment stored count
                      box.write('surprise_refresh_count', refreshCount + 1);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 16,
                            color:
                                glDashboardPrimaryDarkColor, // Your custom theme color
                          ),
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
              ).animate().fadeIn(
                  delay: 200.ms), // Optional: Requires flutter_animate package

              const SizedBox(height: 24),

              // Ingredients Section
              Text(
                "Ingredients Needed:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: glDashboardPrimaryDarkColor,
                ),
              ),
              const SizedBox(height: 16),

              if (controller.surpriseIngredients.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No specific ingredients listed.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              else
                ...controller.surpriseIngredients.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.isVegetarian
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item.isVegetarian ? Icons.eco : Icons.set_meal,
                              color: item.isVegetarian
                                  ? Colors.green
                                  : Colors.orange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            item.amount,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSurpriseMealCard() {
    // Hardcoded colors/icons for "Surprise Meal" style
    final Color mealColor = const Color(0xFFE3F2FD); // Light Blue
    final String mealIcon = "assets/icons/dish.svg";

    // Accessing both controllers
    final CalendarController calController = Get.find<CalendarController>();
    final SurpriseMealController smController =
        Get.find<SurpriseMealController>();

    return Obx(() {
      // PREVENT RED ERROR SCREEN: Check if data is null before accessing
      if (smController.surpriseMeal.value == null) {
        return const SizedBox.shrink();
      }

      final recipe = smController.surpriseMeal.value!;

      return Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        color: glLightPrimaryColor,
                        child: SizedBox(
                          width: 80,
                          height: 112,
                          child: SvgPicture.asset(mealIcon).p(5),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Surprise Recommendation",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                recipe.recipeName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    recipe.calories,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.green),
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: glLightPrimaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Text(recipe.prepTime,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54)),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 12,
                  // ADD OBX HERE
                  child: Obx(() {
                    // Access the value inside Obx so GetX knows to listen to it
                    bool isFav = calController.isSMFavourite.value;

                    return GestureDetector(
                      onTap: () async {
                        bool originalState = calController.isSMFavourite.value;
                        bool newState = !originalState;

                        // Optimistic Update
                        calController.isSMFavourite.value = newState;

                        bool success = false;
                        if (newState) {
                          success = await calController
                              .addSurpriseMealToFavouriteOptimistic(
                                  "surprise_meal");
                        } else {
                          success = await calController
                              .removeSurpriseMealFromFavouriteOptimistic(
                                  "surprise_meal");
                        }

                        if (!success) {
                          calController.isSMFavourite.value = originalState;
                          Get.snackbar(
                              "Error", "Could not update favorite status");
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
                              color: isFav
                                  ? Colors.red.withOpacity(0.35)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: isFav ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: AnimatedScale(
                          scale: isFav ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav
                                ? const Color(0xFFE91E63)
                                : const Color(0xFF9E9E9E),
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Expansion Logic using SurpriseMealController
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Divider(height: 1),
                  InkWell(
                    onTap: smController.toggleExpansion,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            smController.isCardExpanded.value
                                ? "Hide Recipe"
                                : "Show Recipe",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: glAccentColor),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            smController.isCardExpanded.value
                                ? Icons.expand_less
                                : Icons.expand_more,
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        recipe.recipePoints,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.7),
                            height: 1.5),
                      ),
                    ),
                    crossFadeState: smController.isCardExpanded.value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
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
