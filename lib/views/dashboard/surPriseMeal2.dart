import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutri_ai/controllers/surpriseMealController.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core.dart';

class SurpriseMeal extends GetView<SurpriseMealController> {
  const SurpriseMeal({super.key});

  @override
  Widget build(BuildContext context) {
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
    final recipe = controller.surpriseMeal.value!;

    // Hardcoded colors/icons for "Surprise Meal" style
    final Color mealColor = const Color(0xFFE3F2FD); // Light Blue
    final String mealIcon = "assets/icons/dish.svg";

    return Obx(() {
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
              ],
            ),

            // Expansion Logic
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Divider(height: 1),
                  InkWell(
                    onTap: controller.toggleExpansion,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isCardExpanded.value
                                ? "Hide Recipe"
                                : "Show Recipe",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: glAccentColor),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            controller.isCardExpanded.value
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
                    crossFadeState: controller.isCardExpanded.value
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