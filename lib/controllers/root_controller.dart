import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../core.dart';

class RootController extends GetxController {
  RootService rootService = Get.find();
  getAppConfig() async {
    var value = await Helper.sendRequestToServer(endPoint: 'app-config', requestData: {'version': "1.0.0+18"});
    var response = json.decode(value.body);
    if (response["status"]) {
      rootService.config.value = AppConfig.fromJson(response["data"]);
      rootService.config.refresh();
      // rootService.checkIfTesting = (!(RootService.to.config.value.testingAndroid && Platform.isAndroid) && !(RootService.to.config.value.testingIos && Platform.isIOS));
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  saveUserMealPlan() async {
    String chatGptData = """{
  "weekly_diet_chart": [
    {
      "day": "Day 1",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Oats", "quantity": "1 cup", "macros": {"calories": 150, "protein": 5, "carbs": 27, "fats": 3}},
            {"name": "Skimmed Milk", "quantity": "1 cup", "macros": {"calories": 90, "protein": 8, "carbs": 12, "fats": 0}},
            {"name": "Almonds", "quantity": "10 pieces", "macros": {"calories": 70, "protein": 3, "carbs": 2, "fats": 6}},
            {"name": "Boiled Eggs", "quantity": "2", "macros": {"calories": 140, "protein": 12, "carbs": 1, "fats": 10}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Apple", "quantity": "1 medium", "macros": {"calories": 95, "protein": 0.5, "carbs": 25, "fats": 0}},
            {"name": "Whey Protein", "quantity": "1 scoop", "macros": {"calories": 120, "protein": 24, "carbs": 3, "fats": 1}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Grilled Chicken", "quantity": "150g", "macros": {"calories": 300, "protein": 35, "carbs": 0, "fats": 16}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Steamed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}},
            {"name": "Yogurt", "quantity": "1 small bowl", "macros": {"calories": 80, "protein": 4, "carbs": 12, "fats": 2}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Paneer Tikka", "quantity": "100g", "macros": {"calories": 300, "protein": 15, "carbs": 8, "fats": 22}},
            {"name": "Cucumber Slices", "quantity": "1 cup", "macros": {"calories": 16, "protein": 1, "carbs": 4, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Fish Curry", "quantity": "150g", "macros": {"calories": 250, "protein": 30, "carbs": 5, "fats": 12}},
            {"name": "Quinoa", "quantity": "1 cup", "macros": {"calories": 220, "protein": 8, "carbs": 39, "fats": 4}},
            {"name": "Sautéed Spinach", "quantity": "1 cup", "macros": {"calories": 45, "protein": 5, "carbs": 7, "fats": 2}}
          ]
        }
      ]
    },
    {
      "day": "Day 2",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Whole Wheat Toast", "quantity": "2 slices", "macros": {"calories": 140, "protein": 6, "carbs": 28, "fats": 2}},
            {"name": "Peanut Butter", "quantity": "2 tbsp", "macros": {"calories": 190, "protein": 8, "carbs": 6, "fats": 16}},
            {"name": "Egg Whites", "quantity": "3", "macros": {"calories": 51, "protein": 11, "carbs": 1, "fats": 0}},
            {"name": "Whole Egg", "quantity": "1", "macros": {"calories": 70, "protein": 6, "carbs": 1, "fats": 5}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Banana", "quantity": "1 medium", "macros": {"calories": 105, "protein": 1.3, "carbs": 27, "fats": 0}},
            {"name": "Whey Protein", "quantity": "1 scoop", "macros": {"calories": 120, "protein": 24, "carbs": 3, "fats": 1}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Mutton Curry (lean cuts)", "quantity": "150g", "macros": {"calories": 350, "protein": 30, "carbs": 5, "fats": 25}},
            {"name": "Whole Wheat Chapati", "quantity": "2", "macros": {"calories": 240, "protein": 8, "carbs": 40, "fats": 6}},
            {"name": "Mixed Salad", "quantity": "1 bowl", "macros": {"calories": 100, "protein": 3, "carbs": 18, "fats": 4}},
            {"name": "Yogurt", "quantity": "1 small bowl", "macros": {"calories": 80, "protein": 4, "carbs": 12, "fats": 2}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Mixed Nuts", "quantity": "1 handful", "macros": {"calories": 200, "protein": 5, "carbs": 6, "fats": 18}},
            {"name": "Green Tea", "quantity": "1 cup", "macros": {"calories": 2, "protein": 0, "carbs": 0, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Tandoori Chicken", "quantity": "150g", "macros": {"calories": 300, "protein": 35, "carbs": 5, "fats": 15}},
            {"name": "Steamed Broccoli", "quantity": "1 cup", "macros": {"calories": 50, "protein": 4, "carbs": 10, "fats": 1}},
            {"name": "Lentils", "quantity": "1 small bowl", "macros": {"calories": 150, "protein": 12, "carbs": 25, "fats": 3}}
          ]
        }
      ]
    },
    {
      "day": "Day 3",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Poha", "quantity": "1 cup", "macros": {"calories": 250, "protein": 4, "carbs": 40, "fats": 5}},
            {"name": "Scrambled Eggs", "quantity": "2", "macros": {"calories": 160, "protein": 12, "carbs": 2, "fats": 12}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Pear", "quantity": "1 medium", "macros": {"calories": 100, "protein": 0.6, "carbs": 27, "fats": 0}},
            {"name": "Almonds", "quantity": "10 pieces", "macros": {"calories": 70, "protein": 3, "carbs": 2, "fats": 6}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Chicken Biryani", "quantity": "1 cup", "macros": {"calories": 350, "protein": 25, "carbs": 45, "fats": 8}},
            {"name": "Mixed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}},
            {"name": "Raita", "quantity": "1 small bowl", "macros": {"calories": 60, "protein": 3, "carbs": 8, "fats": 2}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Greek Yogurt", "quantity": "1 cup", "macros": {"calories": 100, "protein": 10, "carbs": 15, "fats": 2}},
            {"name": "Walnuts", "quantity": "1 handful", "macros": {"calories": 150, "protein": 4, "carbs": 4, "fats": 15}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Grilled Salmon", "quantity": "150g", "macros": {"calories": 350, "protein": 30, "carbs": 0, "fats": 20}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Steamed Broccoli", "quantity": "1 cup", "macros": {"calories": 50, "protein": 4, "carbs": 10, "fats": 1}}
          ]
        }
      ]
    },
    {
      "day": "Day 4",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Multigrain Paratha", "quantity": "1", "macros": {"calories": 220, "protein": 6, "carbs": 35, "fats": 7}},
            {"name": "Yogurt", "quantity": "1 cup", "macros": {"calories": 80, "protein": 4, "carbs": 12, "fats": 2}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Orange", "quantity": "1 medium", "macros": {"calories": 60, "protein": 1, "carbs": 15, "fats": 0}},
            {"name": "Protein Bar", "quantity": "1", "macros": {"calories": 200, "protein": 20, "carbs": 20, "fats": 5}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Rajma (Kidney Beans)", "quantity": "1 cup", "macros": {"calories": 300, "protein": 15, "carbs": 50, "fats": 5}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Salad", "quantity": "1 bowl", "macros": {"calories": 100, "protein": 3, "carbs": 18, "fats": 4}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Paneer Tikka", "quantity": "100g", "macros": {"calories": 300, "protein": 15, "carbs": 8, "fats": 22}},
            {"name": "Green Tea", "quantity": "1 cup", "macros": {"calories": 2, "protein": 0, "carbs": 0, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Chicken Curry", "quantity": "150g", "macros": {"calories": 350, "protein": 30, "carbs": 5, "fats": 20}},
            {"name": "Whole Wheat Chapati", "quantity": "2", "macros": {"calories": 240, "protein": 8, "carbs": 40, "fats": 6}},
            {"name": "Mixed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}}
          ]
        }
      ]
    },
    {
      "day": "Day 5",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Besan Chilla", "quantity": "2", "macros": {"calories": 220, "protein": 12, "carbs": 30, "fats": 6}},
            {"name": "Mint Chutney", "quantity": "1 tbsp", "macros": {"calories": 15, "protein": 1, "carbs": 2, "fats": 0}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Papaya", "quantity": "1 cup", "macros": {"calories": 60, "protein": 1, "carbs": 15, "fats": 0}},
            {"name": "Whey Protein", "quantity": "1 scoop", "macros": {"calories": 120, "protein": 24, "carbs": 3, "fats": 1}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Fish Curry", "quantity": "150g", "macros": {"calories": 250, "protein": 30, "carbs": 5, "fats": 12}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Cucumber Salad", "quantity": "1 bowl", "macros": {"calories": 50, "protein": 1, "carbs": 10, "fats": 0}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Boiled Chickpeas", "quantity": "1 cup", "macros": {"calories": 150, "protein": 8, "carbs": 25, "fats": 2}},
            {"name": "Herbal Tea", "quantity": "1 cup", "macros": {"calories": 2, "protein": 0, "carbs": 0, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Grilled Chicken", "quantity": "150g", "macros": {"calories": 300, "protein": 35, "carbs": 0, "fats": 16}},
            {"name": "Whole Wheat Chapati", "quantity": "2", "macros": {"calories": 240, "protein": 8, "carbs": 40, "fats": 6}},
            {"name": "Steamed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}}
          ]
        }
      ]
    },
    {
      "day": "Day 6",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Moong Dal Chilla", "quantity": "2", "macros": {"calories": 200, "protein": 12, "carbs": 28, "fats": 6}},
            {"name": "Green Chutney", "quantity": "1 tbsp", "macros": {"calories": 15, "protein": 1, "carbs": 2, "fats": 0}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Orange", "quantity": "1 medium", "macros": {"calories": 60, "protein": 1, "carbs": 15, "fats": 0}},
            {"name": "Whey Protein", "quantity": "1 scoop", "macros": {"calories": 120, "protein": 24, "carbs": 3, "fats": 1}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Paneer Bhurji", "quantity": "150g", "macros": {"calories": 300, "protein": 20, "carbs": 10, "fats": 20}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Salad", "quantity": "1 bowl", "macros": {"calories": 100, "protein": 3, "carbs": 18, "fats": 4}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Sprouted Moong", "quantity": "1 cup", "macros": {"calories": 100, "protein": 8, "carbs": 20, "fats": 1}},
            {"name": "Herbal Tea", "quantity": "1 cup", "macros": {"calories": 2, "protein": 0, "carbs": 0, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Mutton Curry", "quantity": "150g", "macros": {"calories": 350, "protein": 30, "carbs": 5, "fats": 25}},
            {"name": "Whole Wheat Chapati", "quantity": "2", "macros": {"calories": 240, "protein": 8, "carbs": 40, "fats": 6}},
            {"name": "Mixed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}}
          ]
        }
      ]
    },
    {
      "day": "Day 7",
      "meals": [
        {
          "meal_time": "Breakfast",
          "food_items": [
            {"name": "Masala Oats", "quantity": "1 cup", "macros": {"calories": 250, "protein": 7, "carbs": 40, "fats": 8}},
            {"name": "Boiled Eggs", "quantity": "2", "macros": {"calories": 140, "protein": 12, "carbs": 1, "fats": 10}}
          ]
        },
        {
          "meal_time": "Morning Snack",
          "food_items": [
            {"name": "Banana", "quantity": "1 medium", "macros": {"calories": 105, "protein": 1.3, "carbs": 27, "fats": 0}},
            {"name": "Almonds", "quantity": "10 pieces", "macros": {"calories": 70, "protein": 3, "carbs": 2, "fats": 6}}
          ]
        },
        {
          "meal_time": "Lunch",
          "food_items": [
            {"name": "Grilled Chicken", "quantity": "150g", "macros": {"calories": 300, "protein": 35, "carbs": 0, "fats": 16}},
            {"name": "Brown Rice", "quantity": "1 cup", "macros": {"calories": 215, "protein": 5, "carbs": 45, "fats": 2}},
            {"name": "Steamed Vegetables", "quantity": "1 cup", "macros": {"calories": 50, "protein": 2, "carbs": 10, "fats": 0}}
          ]
        },
        {
          "meal_time": "Evening Snack",
          "food_items": [
            {"name": "Paneer Tikka", "quantity": "100g", "macros": {"calories": 300, "protein": 15, "carbs": 8, "fats": 22}},
            {"name": "Green Tea", "quantity": "1 cup", "macros": {"calories": 2, "protein": 0, "carbs": 0, "fats": 0}}
          ]
        },
        {
          "meal_time": "Dinner",
          "food_items": [
            {"name": "Fish Curry", "quantity": "150g", "macros": {"calories": 250, "protein": 30, "carbs": 5, "fats": 12}},
            {"name": "Quinoa", "quantity": "1 cup", "macros": {"calories": 220, "protein": 8, "carbs": 39, "fats": 4}},
            {"name": "Steamed Broccoli", "quantity": "1 cup", "macros": {"calories": 50, "protein": 4, "carbs": 10, "fats": 1}}
          ]
        }
      ]
    }
  ]
}
""";
    var chatGptDataJson = jsonDecode(chatGptData);
    var value = await Helper.sendRequestToServer(endPoint: 'save-user-diet-plan', requestData: {'data': chatGptDataJson}, method: "post");
    var response = json.decode(value.body);
    log(response);
    if (!response["status"]) {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Otp";
    } else {
      Helper.dismissToast();
      return "Done";
    }
  }
}
