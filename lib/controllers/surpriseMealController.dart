import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../core.dart';
import 'calendar_controller.dart'; // Importing to reuse RecipeCardData and GroceryItem

class SurpriseMealController extends GetxController {
  final RxBool isLoading = false.obs;

  // Holds the single surprise meal data
  final Rx<RecipeCardData?> surpriseMeal = Rx<RecipeCardData?>(null);

  // Holds the ingredients for the surprise meal
  final RxList<GroceryItem> surpriseIngredients = <GroceryItem>[].obs;

  // Expansion state for the surprise card
  final RxBool isCardExpanded = false.obs;

  void toggleExpansion() {
    isCardExpanded.value = !isCardExpanded.value;
  }

  // --- MODIFIED: Removed BuildContext. No UI logic here. ---
  Future<void> fetchSurpriseMeal({bool isRefresh = false}) async {
    //we can pass isrefresh true when we need to refresh the surprise meal 
    try {
      isLoading.value = true;
      surpriseMeal.value = null;
      surpriseIngredients.clear();
      isCardExpanded.value = false;

      //final int userId = UserService.to.currentUser.value.id;

      final user = UserService.to.currentUser.value;
      debugPrint("Current User: ${user.id}");
      if (user == null) {
        Get.snackbar(
          "Session Error",
          "Please login again.",
          snackPosition: SnackPosition.bottom,
        );
        return;
      }

      final int userId = user.id;

      // --- FIX: Send full timestamp (HH:mm:ss) so the server treats it as a NEW request ---
      // Previous: DateFormat('yyyy-MM-dd') -> "2023-10-27" (Same all day)
      // New: DateFormat('yyyy-MM-dd HH:mm:ss') -> "2023-10-27 14:30:05" (Unique every tap)
      final String date =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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
          final Map<String, dynamic>? outerData = responseData['data'];
          final Map<String, dynamic>? innerData = outerData?['data'];
          final List<dynamic> dietPlan = innerData?['diet_plan'] ?? [];

          if (dietPlan.isNotEmpty) {
            final Map<String, dynamic> planData = dietPlan[0];

            // 1. Parse Meal
            if (planData['meals'] != null && planData['meals'] is Map) {
              final Map<String, dynamic> mealsMap = planData['meals'];
              if (mealsMap.isNotEmpty) {
                String key = mealsMap.keys.first;
                surpriseMeal.value =
                    RecipeCardData.fromMealEntry(key, mealsMap[key]);
              }
            }

            // 2. Parse Ingredients
            if (planData['grocery_list'] != null) {
              final List<dynamic> gl = planData['grocery_list'];
              for (var item in gl) {
                surpriseIngredients.add(GroceryItem.fromJson(item));
              }
            }
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
