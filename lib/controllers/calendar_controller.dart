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
  final RxBool isSMFavourite = false.obs;

  var recipeCards = <RecipeCardData>[].obs;
  var expansionState = <String, bool>{}.obs;

  // Key: Meal Name, Value: List of ingredients
  var groceryListByMeal = <String, List<GroceryItem>>{}.obs;

  final _storage = GetStorage();

  String get _userCacheKey =>
      'dietPlanCache_${UserService.to.currentUser.value.id}';

  final Rx<Map<String, dynamic>> _cachedDietPlan = Rx<Map<String, dynamic>>({});
  // Local reactive variable for the heart state
  final RxSet<int> favouriteTypeSet = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await fetchDataForDate(selectedDate.value);
    await checkIsFavourite();
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

  Future<void> loadFavouriteStatus() async {
    await checkIsFavourite();
  }

  int getMealEnum(String mealName) {
    final name = mealName.toLowerCase();

    if (name.contains("lunch")) return 1;
    if (name.contains("breakfast")) return 2;
    if (name.contains("dinner")) return 3;
    if (name.contains("snack")) return 4;

    return 0;
  }

//check favorite for surprise meal
  Future<bool> checkSM_IsFavourite() async {
    final int userId = UserService.to.currentUser.value.id;

    try {
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'check-SM-isFavourite',
        method: 'post',
        requestData: {
          "user_id": userId,
          "type": "surprise_meal",
          "date": formattedDate,
          'prep_type': "DAY_WISE_MEAL"
        },
      );

      //if (response == null) return;

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['status'] == true) {
        debugPrint("api called uuuuuuuuuuu");

        return json['is_favourite'];
      } else {
        return false;
      }
    } catch (e) {
      print("error to check favourite: $e");
      return false;
    }
  }

//check is favourite
  Future<void> checkIsFavourite() async {
    final int userId = UserService.to.currentUser.value.id;

    try {
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'check-isFavourite',
        method: 'post',
        requestData: {
          "user_id": userId,
          "type": "diet_plan",
          "date": formattedDate,
          'prep_type': "DAY_WISE_MEAL"
        },
      );

      if (response == null) return;

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['status'] == true) {
        String favouriteTypes = json['favourite_types'] ?? "";

        if (favouriteTypes.isNotEmpty) {
          favouriteTypeSet.value = favouriteTypes
              .split(',')
              .map((e) => int.tryParse(e) ?? 0)
              .where((e) => e != 0)
              .toSet();
        } else {
          favouriteTypeSet.clear();
        }
      } else {
        favouriteTypeSet.clear();
      }
    } catch (e) {
      print("error to check favourite: $e");
      favouriteTypeSet.clear();
    }
  }

  Future<bool> addToFavouriteOptimistic(
      String type, String mealType, int mealEnum) async {
    try {
      final int userId = UserService.to.currentUser.value.id;
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'add-favourite-meal',
        method: 'post',
        requestData: {
          'user_id': userId,
          'type': type,
          'prep_type': "DAY_WISE_MEAL",
          'meal_type': mealType,
          'date': formattedDate,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          return true; //  success
        }
      }

      return false; // failed
    } catch (e) {
      print("Add Favourite Error: $e");
      return false;
    }
  }

//new favourite remove function
  Future<bool> removeFromFavouriteOptimistic(
      String type, String mealType, int mealEnum) async {
    try {
      final int userId = UserService.to.currentUser.value.id;
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'remove-isFavourite',
        method: 'post',
        requestData: {
          'user_id': userId,
          'type': type,
          'meal_type': mealType,
          'prep_type': "DAY_WISE_MEAL",
          'date': formattedDate,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          return true; //success
        }
      }

      return false; //failed
    } catch (e) {
      print("Remove Favourite Error: $e");
      return false;
    }
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

//handle surprise meal
  Future<bool> removeSurpriseMealFromFavouriteOptimistic(String type) async {
    try {
      final int userId = UserService.to.currentUser.value.id;
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'remove-isFavourite',
        method: 'post',
        requestData: {
          'user_id': userId,
          'type': type,
          'meal_type': "surprise_meal",
          'prep_type': "DAY_WISE_MEAL",
          'date': formattedDate,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          return true; //success
        }
      }

      return false; //failed
    } catch (e) {
      print("Remove Favourite Error: $e");
      return false;
    }
  }

  Future<bool> addSurpriseMealToFavouriteOptimistic(String type) async {
    try {
      final int userId = UserService.to.currentUser.value.id;
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await Helper.sendRequestToServer(
        endPoint: 'add-favourite-meal',
        method: 'post',
        requestData: {
          'user_id': userId,
          'type': type,
          'prep_type': "DAY_WISE_MEAL",
          'meal_type': "surprise_meal",
          'date': formattedDate,
        },
      );

      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          return true; //  success
        }
      }

      return false; // failed
    } catch (e) {
      print("Add Favourite Error: $e");
      return false;
    }
  }

  Future<void> fetchDataForDate(DateTime date, {bool isRefresh = false}) async {
    debugPrint("called bro - Always Fetching from API");
    try {
      isLoading.value = true;

      // Clear lists only if it's a manual refresh to show "loading" state clearly,
      // otherwise we overwrite the data once received to prevent flickering.
      if (isRefresh) {
        recipeCards.clear();
        groceryListByMeal.clear();
        expansionState.clear();
        favouriteTypeSet.clear();
        //await updateIsFavourite();
      }

      dynamic dayPlan;

      // --- 1. Prepare API Call ---
      final int userId = UserService.to.currentUser.value.id;
      // Ensure you have the intl package imported for DateFormat
      final String apiDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

      print(
          "--- Fetching plan from API for $apiDate (Refresh: $isRefresh) ---");

      final response = await Helper.sendRequestToServer(
        endPoint: 'get-user-meal',
        method: 'post',
        requestData: {
          'user_id': userId,
          'day': 1, // You might want to make this dynamic if needed
          'type': "diet_plan",
          'prep_type': "DAY_WISE_MEAL",
          'date': apiDate,
          'isrefresh': isRefresh ? 1 : 0,
        },
      );

      // --- 2. Handle Response ---
      if (response != null) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status'] == true) {
          final Map<String, dynamic>? outerData = responseData['data'];
          final Map<String, dynamic>? innerData = outerData?['data'];
          final List<dynamic> dietPlanList = outerData?['diet_plan'] ?? [];

          if (dietPlanList.isNotEmpty) {
            // Assign the fetched data to dayPlan
            dayPlan = dietPlanList[0];
          } else {
            // Handle case where data is empty (optional: clear UI or show message)
            print("API returned empty diet plan list");
          }
        } else {
          throw Exception(responseData['msg'] ?? "Failed to load data.");
        }
      } else {
        throw Exception("No response from server.");
      }

      // --- 3. Process Data (Only if dayPlan was found) ---
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

        // Update Reactive Variables
        recipeCards.value = newRecipes;
        groceryListByMeal.value = newGroceryMap;

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
