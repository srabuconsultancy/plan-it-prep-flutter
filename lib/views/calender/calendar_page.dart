import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart'; // <-- Import for date formatting
import 'package:nutri_ai/controllers/calendar_controller.dart';

import '../../core.dart'; // Ensure this imports CalendarController, AppBarWidget, colors, etc.

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController()); // Ensure controller is initialized

    final Color primaryColor = glLightThemeColor;
    final Color primaryTextColor = glDarkPrimaryColor;
    final Color secondaryTextColor = Colors.grey[600] ?? Colors.grey;
    final Color subtleBackgroundColor =
        glLightDividerColor.withValues(alpha: 0.1);
    final Color cardBackgroundColor = glLightPrimaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              AppBarWidget(
                title: 'Calendar'.tr,
                onTap: () {
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
              ).pSymmetric(h: 15.0),
              const SizedBox(height: 20),

              // --- REMOVED: "Daily/Weekly/Monthly" Toggles ---
              // Obx(() => Row(...

              // --- NEW: Date Selector Row ---
              _buildDateSelectorRow(
                context,
                controller,
                primaryColor,
                primaryTextColor,
              ).pSymmetric(h: 15.0),

              const SizedBox(height: 15),

              // --- REMOVED: "Breakfast/Lunch/Dinner" Toggles ---
              // Obx(() => Row(...

              const SizedBox(height: 25), // Kept original spacing

              // --- Recipe Card(s) Section ---
              Obx(() {
                // --- UPDATED: Use isLoading state from controller ---
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator())
                      .pOnly(top: 50);
                }

                // --- UPDATED: Use recipeCards list from controller ---
                if (controller.recipeCards.isEmpty) {
                  return Center(
                    child: Text(
                      "No recipes found for this day.",
                      style: TextStyle(color: secondaryTextColor, fontSize: 16),
                    ),
                  ).pOnly(top: 50);
                }
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.recipeCards.length,
                  itemBuilder: (context, index) {
                    final cardData = controller.recipeCards[index];
                    return Obx(() {
                      bool isExpanded =
                          controller.expansionState[cardData.uniqueKey] ??
                              false;
                      return _buildMealCard(
                        cardData: cardData,
                        isExpanded: isExpanded,
                        onExpandTap: () =>
                            controller.toggleCardExpansion(cardData.uniqueKey),
                        primaryColor: primaryColor,
                        primaryTextColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        cardBackgroundColor: cardBackgroundColor,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                          .slideX(begin: 0.1);
                    });
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- NEW: Date Selector Row Widget ---
  Widget _buildDateSelectorRow(
    BuildContext context,
    CalendarController controller,
    Color primaryColor,
    Color primaryTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date display
        Obx(() {
          String dateText;
          // Assumes 'selectedDate' exists in your controller
          final selected = controller.selectedDate.value;
          final now = DateTime.now();

          if (selected.year == now.year &&
              selected.month == now.month &&
              selected.day == now.day) {
            dateText = "Today, ${DateFormat('d MMM').format(selected)}";
          } else {
            dateText = DateFormat('E, d MMM').format(selected);
          }

          return Text(
            dateText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          );
        }),
        // Calendar Icon Button
        IconButton(
          icon: Icon(Icons.calendar_month_outlined,
              color: primaryColor, size: 28),
          onPressed: () => _selectDate(context, controller),
        ),
      ],
    );
  }

  // --- NEW: Date Picker Function ---
  Future<void> _selectDate(
      BuildContext context, CalendarController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      // Restrict to today...
      firstDate: DateTime(now.year, now.month, now.day),
      // ...and 30 days in the future
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        // Theme the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: glLightThemeColor, // Header background
              onPrimary: Colors.white, // Header text
              onSurface: glDarkPrimaryColor, // Body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: glLightThemeColor, // Button text
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.selectedDate.value) {
      // Assumes 'selectDate' method exists in your controller
      controller.selectDate(picked);
    }
  }

  // --- Helper Widgets ---

  // This widget is no longer called in the build method,
  // but left here as requested.
  Widget _buildToggleChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color unselectedColor,
    required Color selectedTextColor,
    required Color unselectedTextColor,
  }) {
    // ... (same as before)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label.tr,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? selectedTextColor : unselectedTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // --- UPDATED Meal Card Builder ---
  Widget _buildMealCard({
    required RecipeCardData cardData, // <-- Using RecipeCardData from controller
    required bool isExpanded,
    required VoidCallback onExpandTap,
    required Color primaryColor, // This is glLightThemeColor
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color cardBackgroundColor,
  }) {
    String vegNonVegIconAsset = cardData.isVegetarian
        ? "assets/icons/veg.svg"
        : "assets/icons/non-veg.svg";

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(glBorderRadius - 2)),
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Row ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(vegNonVegIconAsset, width: 20, height: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cardData.recipeName,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  cardData.day, // This will now show "Breakfast", "Lunch", etc.
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // --- Bottom Row (Prep/Calories) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  icon: Icons.timer_outlined,
                  label: "Preparation Time",
                  value: cardData.prepTime,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildInfoColumn(
                  icon: Icons.whatshot_outlined,
                  label: "Calories",
                  value: cardData.calories,
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),

            // --- Divider ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.grey.withOpacity(0.15), height: 1),
            ),

            // --- Expand Button Row ---
            InkWell(
              onTap: onExpandTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isExpanded ? "Hide Recipe".tr : "Show Recipe".tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: glLightButtonBGColor, // <-- CHANGE HERE
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: glLightButtonBGColor, // <-- CHANGE HERE
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            // --- Expandable Section ---
            AnimatedCrossFade(
              firstChild: Container(height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 4.0, right: 4.0, bottom: 4.0),
                child: Text(
                  cardData.recipePoints,
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryTextColor.withOpacity(0.7),
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
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    // ... (same as before)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: TextStyle(
            fontSize: 11,
            color: secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(icon, color: primaryTextColor.withOpacity(0.8), size: 16),
            const SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Placeholder logic for veg/non-veg
  bool _isRecipeVegetarian(String recipeName) {
    if (recipeName.toLowerCase().contains('chicken') ||
        recipeName.toLowerCase().contains('egg')) {
      return false;
    }
    return true;
  }
}

