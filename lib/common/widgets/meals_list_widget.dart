import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core.dart';

class MealPlanListWidget extends StatefulWidget {
  final Function()? onTap;
  final MealPlan? mealPlan;
  final bool isMyDailyMeal;
  const MealPlanListWidget({
    super.key,
    this.onTap,
    this.mealPlan,
    this.isMyDailyMeal = false,
  });

  @override
  State<MealPlanListWidget> createState() => _MealPlanListWidgetState();
}

class _MealPlanListWidgetState extends State<MealPlanListWidget> with SingleTickerProviderStateMixin {
  late ScrollController _tabScrollController;
  var visibleMeals = <Meal>[].obs;
  int selectedIndex = 0;
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    visibleMeals.value = widget.mealPlan?.meals.where((e) => e.mealPlanItems?.isNotEmpty ?? false).toList() ?? [];
    visibleMeals.refresh();
    _pageController = PageController();
    _tabScrollController = ScrollController();
    _tabController = TabController(
      length: visibleMeals.length,
      vsync: this,
    );
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? 0;

      updateSelectedIndex(newIndex);
      scrollTabToCenter(newIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    updateSelectedIndex(index);
    scrollTabToCenter(index);
    animateToPage(index);
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollTabToCenter(int index) {
    //print("scrollTabToCenter");
    final double screenWidth = Get.width;
    final double tabWidth = screenWidth / 3.4;
    final double targetOffset = (index * (tabWidth + 12)) - (screenWidth - tabWidth) / 2;

    _tabScrollController.animateTo(
      targetOffset.clamp(0.0, _tabScrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mealPlan == null || visibleMeals.isEmpty) {
      return const Center(child: Text("No meal plan available."));
    }

    if (!Get.isRegistered<MealPlanController>()) {
      Get.put(MealPlanController());
    }
    final mealPlanController = Get.find<MealPlanController>();

    return Obx(
      () {
        visibleMeals.value = widget.mealPlan?.meals.where((e) => e.mealPlanItems?.isNotEmpty ?? false).toList() ?? [];
        visibleMeals.refresh();
        return Column(
          children: [
            Container(
              height: 46,
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(2),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                controller: _tabScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(visibleMeals.length, (index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        onTabTapped(index);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: Get.width / 3.3,
                        margin: EdgeInsets.only(right: index == visibleMeals.length - 1 ? 0 : 12),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          visibleMeals[index].name!,
                          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 14),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: visibleMeals.map((meal) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              meal.name!,
                              style: Get.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                            ),
                            CustomButtonWidget(
                              bgColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              width: 30,
                              height: 30,
                              onTap: () => mealPlanController.openFoodListForAddToMeal(meal),
                              child: RoundContainer(
                                size: 30,
                                child: Icon(Icons.add_circle, color: glAccentColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          // physics: ClampingScrollPhysics(),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: meal.mealPlanItems!.length,
                          padding: EdgeInsets.zero,

                          /*separatorBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            thickness: 1.5,
                            color: glLightDividerColor.withOpacity(0.15),
                          ).animate().fadeIn(duration: 900.ms, delay: (500.ms + (index * 200).ms)).slideX(),
                        ),*/
                          itemBuilder: (_, index) {
                            final foodItem = meal.mealPlanItems![index];
                            return FoodItemWidget(
                              foodItem: foodItem,
                              onLike: () => mealPlanController.likeFoodItem(foodItemId: foodItem.id!),
                              onDislike: () => mealPlanController.openDislikePopup(foodItemId: foodItem.id),
                              onReplace: () => mealPlanController.openReplacePopup(foodItem: foodItem),
                              onAddButtonTap: () => mealPlanController.openFoodItemDetailPopup(foodItem),
                              showAddButton: true,
                            ).animate().fadeIn(duration: 900.ms, delay: 500.ms + (index * 100).ms).slideX().pOnly(bottom: 10);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
