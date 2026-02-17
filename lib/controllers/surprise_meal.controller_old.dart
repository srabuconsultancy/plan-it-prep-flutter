import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../core.dart';
import 'calendar_controller.dart'; // Importing to reuse RecipeCardData and GroceryItem

class SurpriseMealControllerOld extends GetxController {
  final RxBool isLoading = false.obs;

  // Holds the single surprise meal data
  final Rx<RecipeCardData?> surpriseMeal = Rx<RecipeCardData?>(null);

  // Holds the ingredients for the surprise meal
  final RxList<GroceryItem> surpriseIngredients = <GroceryItem>[].obs;

  // Holds the summary if needed (calories, etc)
  final RxMap<String, dynamic> surpriseSummary = <String, dynamic>{}.obs;

  // Expansion state for the surprise card
  final RxBool isCardExpanded = false.obs;

  void toggleExpansion() {
    isCardExpanded.value = !isCardExpanded.value;
  }

  // --- MODIFIED: Removed BuildContext and UI Logic ---
  Future<void> fetchSurpriseMeal({bool isRefresh = false}) async {
    try {
      isLoading.value = true;
      surpriseMeal.value = null;
      surpriseIngredients.clear();
      surpriseSummary.clear();
      isCardExpanded.value = false;

      final int userId = UserService.to.currentUser.value.id;
      // Using today's date
      final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await Helper.sendRequestToServer(
        endPoint: 'get-surprise-meal',
        method: 'post',
        requestData: {
          'user_id': userId,
          'day': 1,
          'date': date,
          'isrefresh': isRefresh ? 1 : 0,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          final Map<String, dynamic>? data = responseData['data'];
          final List<dynamic> dietPlan = data?['diet_plan'] ?? [];

          if (dietPlan.isNotEmpty) {
            final Map<String, dynamic> planData = dietPlan[0];

            // 1. Parse Meal
            if (planData['meals'] != null && planData['meals'] is Map) {
              final Map<String, dynamic> mealsMap = planData['meals'];
              if (mealsMap.isNotEmpty) {
                // The API returns "Surprise Meal" as the key
                String key = mealsMap.keys.first;
                surpriseMeal.value = RecipeCardData.fromMealEntry(
                    key, mealsMap[key]);
              }
            }

            // 2. Parse Ingredients (Grocery List)
            if (planData['grocery_list'] != null) {
              final List<dynamic> gl = planData['grocery_list'];
              for (var item in gl) {
                surpriseIngredients.add(GroceryItem.fromJson(item));
              }
            }

            // 3. Parse Summary
            if (planData['daily_summary'] != null) {
              surpriseSummary.value = planData['daily_summary'];
            }

            // --- NOTE: UI triggering is now removed from here ---
          } else {
            Get.snackbar("Info", "No surprise meal available for today.");
          }
        } else {
          throw Exception(
              responseData['msg'] ?? "Failed to get surprise meal.");
        }
      } else {
        throw Exception("No response from server.");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not fetch surprise meal. Please try again.",
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("SurpriseMealController Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}