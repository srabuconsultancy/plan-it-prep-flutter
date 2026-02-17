import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import '../../controllers/calendar_controller.dart';
import '../../core.dart';

class GroceryPage extends StatelessWidget {
  const GroceryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure we find the controller
    final CalendarController calendarController = Get.find<CalendarController>();

    return Scaffold(
      backgroundColor: Colors.white,
      // --- MODIFIED: Removed standard AppBar to use custom header ---
      body: SafeArea(
        child: Column(
          children: [
            // --- CUSTOM HEADER (Title + Date Picker) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    "Grocery List",
                    style: TextStyle(
                      color: glDashboardPrimaryDarkColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  
                  // Date Picker Button (Styled like a capsule)
                  InkWell(
                    onTap: () async {
                      // Open Date Picker
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: calendarController.selectedDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: glLightThemeColor, // Selection color
                                onPrimary: Colors.white, // Text on selection
                                onSurface: glDashboardPrimaryDarkColor, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: glLightThemeColor, // Button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      
                      if (picked != null && picked != calendarController.selectedDate.value) {
                        // Update the controller with the new date
                        calendarController.selectDate(picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Obx(() => Text(
                            // Display formatted date: "27 Nov"
                            DateFormat('dd MMM').format(calendarController.selectedDate.value),
                            style: TextStyle(
                              color: glDashboardPrimaryDarkColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.calendar_month_rounded, 
                            color: glDashboardPrimaryDarkColor, 
                            size: 18
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- BODY CONTENT ---
            Expanded(
              child: Obx(() {
                // 1. Loading
                if (calendarController.isLoading.value) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/loader.json',
                      height: 120,
                    ).paddingAll(10),
                  );
                }

                // 2. Empty State
                if (calendarController.groceryListByMeal.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_shopping_cart_outlined,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          "No grocery items found for this day.",
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        // Add a refresh button here just in case
                        TextButton.icon(
                          onPressed: () {
                             calendarController.fetchDataForDate(calendarController.selectedDate.value, isRefresh: true);
                          },
                          icon: Icon(Icons.refresh, color: glLightThemeColor),
                          label: Text("Refresh", style: TextStyle(color: glLightThemeColor)),
                        )
                      ],
                    ),
                  );
                }

                // 3. Data State
                final List<String> mealOrder = [
                  "Breakfast",
                  "Morning Snack",
                  "Lunch",
                  "Evening Snack",
                  "Dinner", 
                  "Supper"
                ];

                final sortedKeys = calendarController.groceryListByMeal.keys.toList()
                  ..sort((a, b) {
                    int indexA = mealOrder.indexOf(a);
                    int indexB = mealOrder.indexOf(b);
                    if (indexA == -1) indexA = 999;
                    if (indexB == -1) indexB = 999;
                    return indexA.compareTo(indexB);
                  });

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: sortedKeys.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final mealName = sortedKeys[index];
                    final ingredients =
                        calendarController.groceryListByMeal[mealName]!;

                    return _buildMealGrocerySection(mealName, ingredients)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                        .slideX(begin: 0.1);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealGrocerySection(String mealName, List<GroceryItem> ingredients) {
    Color sectionColor;
    if (mealName == "Breakfast") {
      sectionColor = const Color(0xFFFEEAE6);
    } else if (mealName == "Lunch") {
      sectionColor = const Color(0xFFE8F5E9);
    } else if (mealName == "Dinner") {
      sectionColor = const Color(0xFFE0F7FA);
    } else {
      sectionColor = const Color(0xFFFFF3E0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: sectionColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: glDashboardPrimaryDarkColor.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mealName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: glDashboardPrimaryDarkColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "(${ingredients.length})",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ingredients.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final item = ingredients[i];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    item.isVegetarian ? Icons.eco : Icons.set_meal,
                    color: item.isVegetarian ? Colors.green : Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (item.amount.isNotEmpty)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.amount,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}