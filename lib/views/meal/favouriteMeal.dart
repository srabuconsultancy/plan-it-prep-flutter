import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core.dart'; // Ensure this contains your color constants

class FavouriteMealPage extends StatefulWidget {
  const FavouriteMealPage({super.key});

  @override
  State<FavouriteMealPage> createState() => _FavouriteMealPageState();
}

class _FavouriteMealPageState extends State<FavouriteMealPage> {
  bool isLoading = true;
  List favouriteMeals = [];
  // Using a Set to track expanded IDs for smoother performance
  final Set<int> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) fetchFavouriteMeal();
    });
  }

  // --- API LOGIC ---

  Future<void> fetchFavouriteMeal() async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);

      final int userId = UserService.to.currentUser.value.id;
      final response = await Helper.sendRequestToServer(
        endPoint: 'get-favourite-meal',
        method: 'post',
        requestData: {'user_id': userId},
      );

      if (response != null) {
        final data = jsonDecode(response.body);
        if (data["status"] == true && mounted) {
          setState(() {
            favouriteMeals = data["data"];
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<bool> deleteFavourite(int favouriteId) async {
    try {
      final response = await Helper.sendRequestToServer(
        endPoint: 'delete-favourite-meal',
        method: 'post',
        requestData: {"id": favouriteId},
      );
      if (response == null) return false;
      final Map<String, dynamic> json = jsonDecode(response.body);
      return response.statusCode == 200 && json['status'] == true;
    } catch (e) {
      return false;
    }
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("My Favourite Meals",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: glDashboardPrimaryDarkColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favouriteMeals.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: fetchFavouriteMeal,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: favouriteMeals.length,
                    itemBuilder: (context, index) {
                      return _buildIndividualMealCard(
                              favouriteMeals[index], index)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (index * 50).ms)
                          .slideX(begin: 0.1, end: 0);
                    },
                  ),
                ),
    );
  }

  Widget _buildIndividualMealCard(Map<String, dynamic> item, int index) {
    final int id = item["id"];
    final String mealType = item["meal_type"] ?? "Meal";
    // Using created_at from the root of the item
    final String dateStr = item["created_at"].toString().split('T')[0];

    // UPDATED: Extracting data directly from the item based on your new JSON structure
    final String recipeName = item["recipeName"] ?? "Unknown Recipe";
    final String instructions = item["recipePoints"] ?? "";
    final String calories = item["calories"] ?? "";
    final String prepTime = item["prepTime"] ?? "";
    final bool isExpanded = _expandedIds.contains(id);

    // Dynamic Styling based on original meal type for visual variety
    Color accentColor;
    String iconPath;

    switch (mealType.toLowerCase()) {
      case 'breakfast':
        accentColor = const Color(0xFFFF7043);
        iconPath = "assets/icons/breakfast.svg";
        break;
      case 'lunch':
        accentColor = const Color(0xFF4CAF50);
        iconPath = "assets/icons/dish.svg";
        break;
      case 'dinner':
        accentColor = const Color(0xFF5C6BC0);
        iconPath = "assets/icons/supper.svg";
        break;
      default:
        accentColor = glAccentColor;
        iconPath = "assets/icons/morning-snack.svg";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Top Bar showing Sequenced Meal Number and Date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: accentColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MEAL ${index + 1}",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ),

            ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(iconPath,
                    width: 28,
                    height: 28,
                    colorFilter:
                        ColorFilter.mode(accentColor, BlendMode.srcIn)),
              ),
              title: Text(
                recipeName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildMiniBadge(Icons.timer_outlined, prepTime),
                    const SizedBox(width: 12),
                    _buildMiniBadge(
                        Icons.local_fire_department_outlined, calories),
                  ],
                ),
              ),
              trailing: IconButton(
                onPressed: () => _confirmDelete(id),
                icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              ),
            ),

            // Action Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedIds.remove(id);
                          } else {
                            _expandedIds.add(id);
                          }
                        });
                      },
                      icon: Icon(
                        isExpanded ? Icons.unfold_less : Icons.restaurant,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        isExpanded ? "Hide Recipe" : "View Recipe",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Expandable Recipe Section
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cooking Instructions",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      instructions,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.1, end: 0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // --- DELETE LOGIC ---

  void _confirmDelete(int id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Remove from Favourites?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text("This meal will be removed from your saved list.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Keep it"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      Navigator.pop(context);
                      _processDeletion(id);
                    },
                    child: const Text("Delete",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _processDeletion(int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    bool success = await deleteFavourite(id);

    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    if (success) {
      fetchFavouriteMeal();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Meal removed"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No favourite meals yet",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
