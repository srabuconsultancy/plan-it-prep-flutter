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

  final CalendarController calController = Get.find<CalendarController>();

  // Holds the ingredients for the surprise meal
  final RxList<GroceryItem> surpriseIngredients = <GroceryItem>[].obs;

  // Expansion state for the surprise card
  final RxBool isCardExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    calController.isSMFavourite.value =
        await calController.checkSM_IsFavourite();
  }

  void toggleExpansion() {
    isCardExpanded.value = !isCardExpanded.value;
  }

  // --- MODIFIED: Removed BuildContext. No UI logic here. ---
  Future<void> fetchSurpriseMeal({bool isRefresh = false}) async {
    try {
      isLoading.value = true;
      calController.isSMFavourite.value = false;
      surpriseMeal.value = null;
      surpriseIngredients.clear();
      isCardExpanded.value = false;

      final user = UserService.to.currentUser.value;
      if (user == null) {
        Get.snackbar(
          "Session Error",
          "Please login again.",
          snackPosition: SnackPosition.bottom,
        );
        return;
      }

      final int userId = user.id;

      final String date =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      final response = await Helper.sendRequestToServer(
        endPoint: 'get-user-meal',
        method: 'post',
        requestData: {
          'user_id': userId,
          'day': 1,
          'date': date,
          'type': "surprise_meal",
          'prep_type': "DAY_WISE_MEAL",
          'isrefresh': isRefresh ? 1 : 0,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          final Map<String, dynamic>? outerData = responseData['data'];
          final List<dynamic> dietPlan = outerData?['diet_plan'] ?? [];

          if (dietPlan.isNotEmpty) {
            final Map<String, dynamic> planData = dietPlan[0];

            if (planData['meals'] != null && planData['meals'] is Map) {
              final Map<String, dynamic> mealsMap = planData['meals'];

              if (mealsMap.isNotEmpty) {
                String key = mealsMap.keys.first;
                final Map<String, dynamic> mealData = mealsMap[key];

                // 1. Parse Meal
                surpriseMeal.value =
                    RecipeCardData.fromMealEntry(key, mealData);

               

                // 2. Parse Ingredients (Nested inside the meal object per your JSON)
                if (mealData['grocery_list'] != null &&
                    mealData['grocery_list'] is List) {
                  final List<dynamic> gl = mealData['grocery_list'];
                  for (var item in gl) {
                    surpriseIngredients.add(GroceryItem.fromJson(item));
                  }
                }
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

       bool favStatus = await calController.checkSM_IsFavourite();
       calController.isSMFavourite.value = favStatus;
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
