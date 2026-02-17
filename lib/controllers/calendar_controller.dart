import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../core.dart';
import 'package:http/http.dart' as http;

class RecipeCardData {
  final String uniqueKey;
  final String recipeName;
  final String day;
  final String prepTime;
  final String calories;
  final bool isVegetarian;
  final String recipePoints;

  RecipeCardData({
    required this.uniqueKey,
    required this.recipeName,
    required this.day,
    required this.prepTime,
    required this.calories,
    required this.isVegetarian,
    required this.recipePoints,
  });

  factory RecipeCardData.fromMealEntry(
      String mealName, Map<String, dynamic> mealData) {
    return RecipeCardData(
      day: mealName,
      uniqueKey: mealData['uniqueKey'] ??
          '${mealName}_${DateTime.now().millisecondsSinceEpoch}',
      recipeName: mealData['recipeName'] ?? 'N/A',
      prepTime: mealData['prepTime'] ?? 'N/A',
      calories: mealData['calories'] ?? '0 kcal',
      isVegetarian: mealData['isVegetarian'] ?? true,
      recipePoints: mealData['recipePoints'] ?? 'No recipe steps available.',
    );
  }
}

class GroceryItem {
  final String name;
  final String amount;
  final bool isVegetarian;

  GroceryItem({
    required this.name,
    required this.amount,
    required this.isVegetarian,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json['name'] ?? 'Unknown Item',
      amount: json['amount'] ?? '',
      isVegetarian: json['isVegetarian'] ?? true,
    );
  }
}

class CalendarController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isLoading = true.obs;

  var recipeCards = <RecipeCardData>[].obs;
  var expansionState = <String, bool>{}.obs;

  // Key: Meal Name, Value: List of ingredients
  var groceryListByMeal = <String, List<GroceryItem>>{}.obs;

  final _storage = GetStorage();

  String get _userCacheKey =>
      'dietPlanCache_${UserService.to.currentUser.value.id}';

  final Rx<Map<String, dynamic>> _cachedDietPlan = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchDataForDate(selectedDate.value);
  }

  void selectDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchDataForDate(newDate, isRefresh: false);
  }

  void toggleCardExpansion(String cardKey) {
    bool isCurrentlyExpanded = expansionState[cardKey] ?? false;
    expansionState[cardKey] = !isCurrentlyExpanded;
    expansionState.refresh();
  }

  String _formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  int _getMealPriority(String mealName) {
    final name = mealName.toLowerCase().trim();
    if (name.contains('breakfast')) return 1;
    if (name.contains('morning')) return 2;
    if (name.contains('lunch')) return 3;
    if (name.contains('evening')) return 4;
    if (name.contains('dinner')) return 5;
    if (name.contains('supper')) return 6;
    return 99;
  }

  Future<void> deleteAiResponseOfToday(String type) async {
    try {
      final user = UserService.to.currentUser.value;
      if (user == null) return;

      final response = await Helper.sendRequestToServer(
        endPoint: 'delete-Ai-Response',
        method: 'post',
        requestData: {
          'user_id': user.id,
          "type": type,
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Deleted today's AI response");
      } else {
        debugPrint("Delete failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Delete error (ignored): $e");
    }
  }

  Future<void> fetchDataForDate(DateTime date, {bool isRefresh = false}) async {
    debugPrint("called bro");
    try {
      isLoading.value = true;
      if (isRefresh) {
        recipeCards.clear();
        groceryListByMeal.clear();
        expansionState.clear();
      }

      final String dateKey = _formatDateKey(date);
      dynamic dayPlan;

      final String cacheKey = _userCacheKey;
      final storedCache = _storage.read(cacheKey);
      if (storedCache is Map) {
        _cachedDietPlan.value = Map<String, dynamic>.from(storedCache);
      } else {
        _cachedDietPlan.value = {};
      }

      if (!isRefresh && _cachedDietPlan.value.containsKey(dateKey)) {
        print("--- Loading plan from PERSISTENT CACHE for $dateKey ---");
        dayPlan = _cachedDietPlan.value[dateKey];
      } else {
        print(
            "--- Fetching plan from API for $dateKey (Refresh: $isRefresh) ---");
        final int userId = UserService.to.currentUser.value.id;
        final String apiDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

        final response = await Helper.sendRequestToServer(
          endPoint: 'get-full-diet-plan',
          method: 'post',
          requestData: {
            'user_id': userId,
            'day': 1,
            'date': apiDate,
            'isrefresh': isRefresh ? 1 : 0,
          },
        );


        if (response != null) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (response.statusCode == 200 && responseData['status'] == true) {
            final Map<String, dynamic>? outerData = responseData['data'];
            final Map<String, dynamic>? innerData = outerData?['data'];
            final List<dynamic> dietPlanList = innerData?['diet_plan'] ?? [];

            if (dietPlanList.isNotEmpty) {
              dayPlan = dietPlanList[0];

              // Save to cache
              _cachedDietPlan.value[dateKey] = dayPlan;
              _cachedDietPlan.refresh();
              await _storage.write(cacheKey, _cachedDietPlan.value);
            }
          } else {
            throw Exception(responseData['msg'] ?? "Failed to load data.");
          }
        } else {
          throw Exception("No response from server.");
        }
      }

      // --- PROCESSING DATA ---
      if (dayPlan != null) {
        final Map<String, dynamic> meals = dayPlan['meals'] ?? {};
        final List<RecipeCardData> newRecipes = [];
        final Map<String, List<GroceryItem>> newGroceryMap = {};

        meals.forEach((mealName, mealDataRaw) {
          if (mealDataRaw is Map<String, dynamic>) {
            final mealData = mealDataRaw;

            // 1. Recipe Card
            newRecipes.add(RecipeCardData.fromMealEntry(mealName, mealData));

            // 2. Grocery List (Check nested 'grocery_list')
            if (mealData['grocery_list'] != null) {
              final List<dynamic> gl = mealData['grocery_list'];
              List<GroceryItem> items = [];
              for (var itemData in gl) {
                items.add(GroceryItem.fromJson(itemData));
              }
              if (items.isNotEmpty) {
                newGroceryMap[mealName] = items;
              }
            }
          }
        });

        // Sort Recipes
        newRecipes.sort((a, b) {
          int priorityA = _getMealPriority(a.day);
          int priorityB = _getMealPriority(b.day);
          return priorityA.compareTo(priorityB);
        });

        recipeCards.value = newRecipes;
        groceryListByMeal.value = newGroceryMap;

        // Debug Print
        print("Parsed ${newGroceryMap.length} meals with grocery items.");
      }
    } catch (e) {
      Get.snackbar("Error", "Please try refreshing.");
      print("CalendarController Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
