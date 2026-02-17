import 'package:get/get.dart';

// --- Define a simple GroceryItem model ---
class GroceryItem {
  final String name;
  final String amount;
  final bool isVegetarian;

  GroceryItem({
    required this.name,
    required this.amount,
    required this.isVegetarian,
  });
}

class GroceryController extends GetxController {
  // --- State for Toggle Buttons ---
  var selectedPeriod = "Daily".obs; // Default to Daily

  // --- State for Grocery List ---
  var groceryList = <GroceryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _updateGroceryList(); // Load initial data
  }

  // --- Logic Functions ---

  void selectPeriod(String period) {
    selectedPeriod.value = period;
    _updateGroceryList();
  }

  // --- Updated Data Fetching Logic ---
  void _updateGroceryList() {
    String period = selectedPeriod.value;
    groceryList.clear(); // Clear the list

    // --- Replace this with your actual API call and data mapping ---
    if (period == "Daily") {
      groceryList.addAll([
        GroceryItem(name: "Oats", amount: "100g", isVegetarian: true),
        GroceryItem(name: "Apple", amount: "1 piece", isVegetarian: true),
        GroceryItem(name: "Chicken Breast", amount: "200g", isVegetarian: false),
        GroceryItem(name: "Broccoli", amount: "150g", isVegetarian: true),
      ]);
    } else if (period == "Weekly") {
      groceryList.addAll([
        GroceryItem(name: "Oats", amount: "700g", isVegetarian: true),
        GroceryItem(name: "Apples", amount: "7 pieces", isVegetarian: true),
        GroceryItem(name: "Chicken Breast", amount: "1.4kg", isVegetarian: false),
        GroceryItem(name: "Broccoli", amount: "1kg", isVegetarian: true),
        GroceryItem(name: "Rice", amount: "500g", isVegetarian: true),
        GroceryItem(name: "Spinach", amount: "300g", isVegetarian: true),
        GroceryItem(name: "Eggs", amount: "1 dozen", isVegetarian: false),
        GroceryItem(name: "Milk", amount: "2L", isVegetarian: true),
      ]);
    } else if (period == "Monthly") {
      groceryList.addAll([
        GroceryItem(name: "Oats", amount: "3kg", isVegetarian: true),
        GroceryItem(name: "Apples", amount: "30 pieces", isVegetarian: true),
        GroceryItem(name: "Chicken Breast", amount: "6kg", isVegetarian: false),
        GroceryItem(name: "Broccoli", amount: "4kg", isVegetarian: true),
        GroceryItem(name: "Rice", amount: "2kg", isVegetarian: true),
        GroceryItem(name: "Spinach", amount: "1.2kg", isVegetarian: true),
        GroceryItem(name: "Eggs", amount: "4 dozen", isVegetarian: false),
        GroceryItem(name: "Milk", amount: "8L", isVegetarian: true),
        GroceryItem(name: "Lentils", amount: "1kg", isVegetarian: true),
        GroceryItem(name: "Olive Oil", amount: "1L", isVegetarian: true),
      ]);
    }

    groceryList.refresh(); // Notify listeners
  }
}